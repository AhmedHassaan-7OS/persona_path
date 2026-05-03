"""
PersonaPath — Database Engine & Session

Creates the async SQLAlchemy engine connected to Neon PostgreSQL
and provides a session dependency for FastAPI routes.
"""

from sqlmodel import SQLModel
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker
from sqlmodel.ext.asyncio.session import AsyncSession
from .config import config

import ssl as _ssl

# Neon requires SSL
_ssl_ctx = _ssl.create_default_context()
_ssl_ctx.check_hostname = False
_ssl_ctx.verify_mode = _ssl.CERT_NONE

# Create async engine (Neon PostgreSQL)
engine = create_async_engine(
    config.DB_URL,
    echo=True,
    future=True,
    connect_args={"ssl": _ssl_ctx},
)


async def init_db():
    """Create all tables defined in SQLModel metadata."""
    async with engine.begin() as conn:
        await conn.run_sync(SQLModel.metadata.create_all)


async_session = async_sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autoflush=False,
)


async def get_session():
    """FastAPI dependency — yields an async database session."""
    async with async_session() as session:
        yield session