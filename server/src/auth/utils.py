"""
PersonaPath — Auth Utilities

JWT token creation/decoding and password hashing via bcrypt.
"""

import uuid
import logging
from datetime import datetime, timedelta, timezone

import bcrypt
import jwt

from src.db.config import config


# ─── Password Hashing ───


def hash_password(password: str) -> str:
    """Hash a password using bcrypt."""
    password_bytes = password.encode("utf-8")[:72]
    salt = bcrypt.gensalt(config.BCRYPT_ROUNDS)
    hashed = bcrypt.hashpw(password_bytes, salt)
    return hashed.decode("utf-8")


def verify_password(password: str, hashed_password: str) -> bool:
    """Verify a password against a bcrypt hash."""
    password_bytes = password.encode("utf-8")[:72]
    hashed_bytes = hashed_password.encode("utf-8")
    return bcrypt.checkpw(password_bytes, hashed_bytes)


# ─── JWT Tokens ───


def create_token(
    user_data: dict,
    expire: timedelta | None = None,
    refresh: bool = False,
) -> str:
    """Create a JWT access or refresh token."""
    default_expire = timedelta(minutes=config.ACCESS_TOKEN_EXPIRE_MINUTES)
    payload = {
        "user": user_data,
        "exp": datetime.now(timezone.utc) + (expire or default_expire),
        "jti": str(uuid.uuid4()),
        "refresh_token": refresh,
    }
    return jwt.encode(
        payload=payload,
        key=config.JWT_SECRET,
        algorithm=config.JWT_ALGORITHM,
    )


def decode_token(token: str) -> dict | None:
    """Decode and verify a JWT token. Returns payload or None."""
    try:
        return jwt.decode(
            jwt=token,
            key=config.JWT_SECRET,
            algorithms=[config.JWT_ALGORITHM],
        )
    except jwt.exceptions.ExpiredSignatureError:
        logging.warning("Token expired")
        return None
    except jwt.InvalidTokenError:
        logging.warning("Invalid token")
        return None
    except Exception as e:
        logging.exception(f"Unknown token error: {e}")
        return None
