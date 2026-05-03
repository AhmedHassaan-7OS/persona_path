"""
PersonaPath — Auth Routes

Endpoints:
  POST /signup       — Email/password registration
  POST /login        — Email/password login
  POST /google       — Google Sign-In (Firebase ID token)
  GET  /me           — Get current user profile
  PATCH /profile     — Update username
  POST /refresh      — Refresh access token
  POST /logout       — Blacklist current token
  DELETE /account    — Delete user account
"""

from datetime import timedelta

from fastapi import APIRouter, Depends, status
from fastapi.exceptions import HTTPException
from fastapi.responses import JSONResponse
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlalchemy.exc import IntegrityError

from src.db.main import get_session
from src.db.config import config
from src.db.redis import add_to_blacklist

from .schema import (
    SignUpRequest,
    LoginRequest,
    GoogleSignInRequest,
    UpdateProfileRequest,
    UserResponse,
    AuthResponse,
)
from .service import UserService
from .utils import create_token, verify_password
from .dependencies import AccessTokenBearer, RefreshTokenBearer, get_current_user
from .firebase_verify import verify_firebase_token
from src.db.models import User


auth_router = APIRouter()
user_service = UserService()

access_expire = timedelta(minutes=config.ACCESS_TOKEN_EXPIRE_MINUTES)
refresh_expire = timedelta(days=config.REFRESH_TOKEN_EXPIRE_DAYS)


def _build_token_data(user: User) -> dict:
    """Build the payload stored inside JWTs."""
    return {
        "email": user.email,
        "uid": user.uid,
        "username": user.username,
    }


def _build_auth_response(user: User, message: str) -> AuthResponse:
    """Create a full auth response with tokens + user data."""
    token_data = _build_token_data(user)
    return AuthResponse(
        message=message,
        access_token=create_token(token_data, expire=access_expire),
        refresh_token=create_token(token_data, expire=refresh_expire, refresh=True),
        user=UserResponse.model_validate(user),
    )


# ─── Email/Password Registration ───


@auth_router.post(
    "/signup",
    response_model=AuthResponse,
    status_code=status.HTTP_201_CREATED,
)
async def signup(
    data: SignUpRequest,
    session: AsyncSession = Depends(get_session),
):
    # Check duplicates
    if await user_service.user_exists(data.email, session):
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Email already registered",
        )
    if await user_service.username_exists(data.username, session):
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Username already taken",
        )

    try:
        user = await user_service.create_user(
            username=data.username,
            email=data.email,
            password=data.password,
            auth_provider="email",
            session=session,
        )
    except IntegrityError:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Email or username already exists",
        )

    return _build_auth_response(user, "Account created successfully")


# ─── Email/Password Login ───


@auth_router.post("/login")
async def login(
    data: LoginRequest,
    session: AsyncSession = Depends(get_session),
):
    user = await user_service.get_user_by_email(data.email, session)

    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password",
        )

    if not user.password_hash:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="This account uses Google Sign-In. Please sign in with Google.",
        )

    if not verify_password(data.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password",
        )

    return _build_auth_response(user, "Login successful")


# ─── Google Sign-In ───


@auth_router.post("/google")
async def google_sign_in(
    data: GoogleSignInRequest,
    session: AsyncSession = Depends(get_session),
):
    # Verify the Firebase ID token
    firebase_user = verify_firebase_token(data.id_token)
    if not firebase_user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid Google Sign-In token",
        )

    firebase_uid = firebase_user["firebase_uid"]
    email = firebase_user["email"]
    name = firebase_user["name"]

    # Check if user already exists (by google_id or email)
    user = await user_service.get_user_by_google_id(firebase_uid, session)

    if not user:
        # Check if email exists (user previously registered with email)
        user = await user_service.get_user_by_email(email, session)
        if user:
            # Link Google account to existing email user
            user.google_id = firebase_uid
            user.auth_provider = "google"
            await session.commit()
            await session.refresh(user)
        else:
            # Create new user from Google
            username = _generate_username(name, email)
            # Ensure username uniqueness
            base_username = username
            counter = 1
            while await user_service.username_exists(username, session):
                username = f"{base_username}_{counter}"
                counter += 1

            user = await user_service.create_user(
                username=username,
                email=email,
                password=None,
                auth_provider="google",
                google_id=firebase_uid,
                session=session,
            )

    return _build_auth_response(user, "Google Sign-In successful")


def _generate_username(name: str, email: str) -> str:
    """Generate a username from Google name or email."""
    if name:
        # "John Doe" → "john_doe"
        return name.lower().replace(" ", "_")[:50]
    # fallback from email
    at = email.index("@") if "@" in email else len(email)
    return email[:at].lower().replace(".", "_")[:50]


# ─── Get Current User ───


@auth_router.get("/me", response_model=UserResponse)
async def get_me(user: User = Depends(get_current_user)):
    return user


# ─── Update Profile ───


@auth_router.patch("/profile", response_model=UserResponse)
async def update_profile(
    data: UpdateProfileRequest,
    user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
):
    if await user_service.username_exists(data.username, session):
        existing = await user_service.get_user_by_email(user.email, session)
        if existing and existing.username != data.username:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Username already taken",
            )

    try:
        updated_user = await user_service.update_username(user.uid, data.username, session)
        return updated_user
    except ValueError:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
        )


# ─── Refresh Token ───


@auth_router.post("/refresh")
async def refresh_token(token: dict = Depends(RefreshTokenBearer())):
    new_access = create_token(
        user_data=token["user"],
        expire=access_expire,
    )
    return JSONResponse(content={"access_token": new_access})


# ─── Logout ───


@auth_router.post("/logout")
async def logout(token: dict = Depends(AccessTokenBearer())):
    await add_to_blacklist(token["jti"])
    return JSONResponse(content={"message": "Logged out successfully"})


# ─── Delete Account ───


@auth_router.delete("/account")
async def delete_account(
    user: User = Depends(get_current_user),
    token: dict = Depends(AccessTokenBearer()),
    session: AsyncSession = Depends(get_session),
):
    success = await user_service.delete_user(user.uid, session)
    if not success:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
        )

    await add_to_blacklist(token["jti"])
    return JSONResponse(content={"message": "Account deleted successfully"})
