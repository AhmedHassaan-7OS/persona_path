"""
PersonaPath — Auth Dependencies

FastAPI dependencies for extracting and validating JWT tokens
from request headers, and resolving the current user.
"""

import logging

from fastapi import Depends, status
from fastapi.exceptions import HTTPException
from fastapi.security import HTTPBearer
from fastapi import Request
from sqlmodel.ext.asyncio.session import AsyncSession

from .utils import decode_token
from .service import UserService
from src.db.main import get_session
from src.db.redis import check_blacklist


class BearerToken(HTTPBearer):
    """Base bearer token extractor — decodes JWT and checks blacklist."""

    def __init__(self, auto_error: bool = True):
        super().__init__(auto_error=auto_error)

    async def __call__(self, request: Request) -> dict:
        creds = await super().__call__(request)
        token_data = decode_token(creds.credentials)

        if not token_data:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid or expired token",
            )

        if await check_blacklist(token_data["jti"]):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Token has been revoked",
            )

        self.verify_token_type(token_data)
        return token_data

    def verify_token_type(self, token: dict):
        """Override in subclasses to enforce access vs refresh."""
        pass


class AccessTokenBearer(BearerToken):
    """Ensures the token is an access token (not refresh)."""

    def verify_token_type(self, token: dict):
        if token.get("refresh_token"):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Please provide an access token, not a refresh token",
            )


class RefreshTokenBearer(BearerToken):
    """Ensures the token is a refresh token."""

    def verify_token_type(self, token: dict):
        if not token.get("refresh_token"):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Please provide a refresh token, not an access token",
            )


async def get_current_user(
    token: dict = Depends(AccessTokenBearer()),
    session: AsyncSession = Depends(get_session),
):
    """Resolve the current authenticated user from the JWT token."""
    email = token["user"]["email"]
    try:
        user_service = UserService()
        user = await user_service.get_user_by_email(email, session)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found",
            )
        return user
    except HTTPException:
        raise
    except Exception as e:
        logging.exception(f"Error fetching user: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to fetch user",
        )