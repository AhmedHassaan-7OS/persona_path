"""
PersonaPath — Auth Pydantic Schemas

Request/response models for authentication endpoints.
"""

from pydantic import BaseModel, Field, EmailStr
from datetime import datetime


# ─── Request Models ───


class SignUpRequest(BaseModel):
    """Email/password registration."""
    username: str = Field(min_length=3, max_length=50)
    email: str = Field(max_length=100)
    password: str = Field(min_length=8, max_length=72)


class LoginRequest(BaseModel):
    """Email/password login."""
    email: str = Field(max_length=100)
    password: str = Field(min_length=8, max_length=72)


class GoogleSignInRequest(BaseModel):
    """Google Sign-In — client sends Firebase ID token."""
    id_token: str


class UpdateProfileRequest(BaseModel):
    """Update user profile (username only for now)."""
    username: str = Field(min_length=3, max_length=50)


# ─── Response Models ───


class UserResponse(BaseModel):
    """Public user data returned from API."""
    uid: int
    username: str
    email: str
    auth_provider: str
    created_at: datetime

    model_config = {"from_attributes": True}


class AuthResponse(BaseModel):
    """Response after successful login/signup."""
    message: str
    access_token: str
    refresh_token: str
    user: UserResponse
