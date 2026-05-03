"""
PersonaPath — Database Models (SQLModel / PostgreSQL)

Tables:
  - User     : app users (email or Google sign-in)
  - Quiz     : personality quiz answers
  - Itinerary: AI-generated travel itineraries
"""

from sqlmodel import SQLModel, Field, Column, Relationship
from sqlalchemy import func, Integer, Text
import sqlalchemy.dialects.postgresql as pg
from datetime import datetime
from typing import List, Optional


class User(SQLModel, table=True):
    __tablename__ = "user"

    uid: int | None = Field(
        default=None,
        sa_column=Column(Integer, primary_key=True, autoincrement=True),
    )
    username: str = Field(max_length=50, unique=True, nullable=False)
    email: str = Field(max_length=100, unique=True, nullable=False)
    password_hash: str | None = Field(default=None, max_length=200)
    auth_provider: str = Field(
        default="email",
        sa_column=Column(pg.VARCHAR(10), nullable=False, server_default="email"),
    )
    google_id: str | None = Field(default=None, max_length=200, unique=True)
    created_at: datetime = Field(
        sa_column=Column(
            pg.TIMESTAMP,
            server_default=func.now(),
            nullable=False,
        )
    )

    # Relationships
    quizzes: List["Quiz"] = Relationship(
        back_populates="user",
        sa_relationship_kwargs={
            "lazy": "selectin",
            "cascade": "all, delete-orphan",
        },
    )
    itineraries: List["Itinerary"] = Relationship(
        back_populates="user",
        sa_relationship_kwargs={
            "lazy": "selectin",
            "cascade": "all, delete-orphan",
        },
    )

    def __repr__(self) -> str:
        return f"User(uid={self.uid}, username={self.username})"


class Quiz(SQLModel, table=True):
    __tablename__ = "quiz"

    qid: int | None = Field(
        default=None,
        sa_column=Column(Integer, primary_key=True, autoincrement=True),
    )
    name: str = Field(max_length=100, nullable=False)
    peace_ans: str = Field(max_length=100, nullable=False)
    landscape_ans: str = Field(max_length=100, nullable=False)
    nightlife_ans: str = Field(max_length=100, nullable=False)
    motv_ans: str = Field(max_length=100, nullable=False)
    duration: int = Field(ge=1, le=30, nullable=False)
    price_range: str = Field(max_length=100, nullable=False)
    trip_desc: str | None = Field(default=None, max_length=500)
    created_at: datetime = Field(
        sa_column=Column(
            pg.TIMESTAMP,
            server_default=func.now(),
            nullable=False,
        )
    )

    # Foreign key
    uid: int = Field(foreign_key="user.uid", nullable=False)

    # Relationships
    user: Optional["User"] = Relationship(back_populates="quizzes")
    itineraries: List["Itinerary"] = Relationship(
        back_populates="quiz",
        sa_relationship_kwargs={"lazy": "selectin"},
    )

    def __repr__(self) -> str:
        return f"Quiz(qid={self.qid}, name={self.name})"


class Itinerary(SQLModel, table=True):
    __tablename__ = "itinerary"

    tid: int | None = Field(
        default=None,
        sa_column=Column(Integer, primary_key=True, autoincrement=True),
    )
    name: str = Field(max_length=100, nullable=False)
    description: str | None = Field(default=None, max_length=500)
    itinerary_content: str = Field(
        sa_column=Column(Text, nullable=False),
    )
    created_at: datetime = Field(
        sa_column=Column(
            pg.TIMESTAMP,
            server_default=func.now(),
            nullable=False,
        )
    )

    # Foreign keys
    qid: int | None = Field(default=None, foreign_key="quiz.qid")
    uid: int = Field(foreign_key="user.uid", nullable=False)

    # Relationships
    user: Optional["User"] = Relationship(back_populates="itineraries")
    quiz: Optional["Quiz"] = Relationship(back_populates="itineraries")

    def __repr__(self) -> str:
        return f"Itinerary(tid={self.tid}, name={self.name})"
