"""
PersonaPath — User Service

CRUD operations for the User model.
"""

from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select

from src.db.models import User
from .utils import hash_password


class UserService:

    async def get_user_by_email(self, email: str, session: AsyncSession) -> User | None:
        """Find a user by email (case-insensitive)."""
        email = email.strip().lower()
        statement = select(User).where(User.email == email)
        result = await session.execute(statement)
        return result.scalar_one_or_none()

    async def get_user_by_uid(self, uid: int, session: AsyncSession) -> User | None:
        """Find a user by UID."""
        statement = select(User).where(User.uid == uid)
        result = await session.execute(statement)
        return result.scalar_one_or_none()

    async def get_user_by_google_id(self, google_id: str, session: AsyncSession) -> User | None:
        """Find a user by their Firebase/Google UID."""
        statement = select(User).where(User.google_id == google_id)
        result = await session.execute(statement)
        return result.scalar_one_or_none()

    async def user_exists(self, email: str, session: AsyncSession) -> bool:
        """Check if a user with this email already exists."""
        user = await self.get_user_by_email(email, session)
        return user is not None

    async def username_exists(self, username: str, session: AsyncSession) -> bool:
        """Check if a username is already taken."""
        statement = select(User).where(User.username == username)
        result = await session.execute(statement)
        return result.scalar_one_or_none() is not None

    async def create_user(
        self,
        username: str,
        email: str,
        password: str | None = None,
        auth_provider: str = "email",
        google_id: str | None = None,
    session: AsyncSession = None,
    ) -> User:
        """Create a new user. Password is hashed before storage."""
        password_hash = hash_password(password) if password else None

        new_user = User(
            username=username,
            email=email.strip().lower(),
            password_hash=password_hash,
            auth_provider=auth_provider,
            google_id=google_id,
        )
        session.add(new_user)
        await session.commit()
        await session.refresh(new_user)
        return new_user

    async def update_username(self, uid: int, new_username: str, session: AsyncSession) -> User:
        """Update a user's username."""
        user = await self.get_user_by_uid(uid, session)
        if not user:
            raise ValueError("User not found")

        user.username = new_username
        await session.commit()
        await session.refresh(user)
        return user

    async def delete_user(self, uid: int, session: AsyncSession) -> bool:
        """Delete a user account (cascades to quizzes and itineraries)."""
        user = await self.get_user_by_uid(uid, session)
        if not user:
            return False

        await session.delete(user)
        await session.commit()
        return True