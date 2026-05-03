"""
PersonaPath — Quiz Pydantic Schemas
"""

from pydantic import BaseModel, Field
from datetime import datetime


class QuizCreate(BaseModel):
    """Request to save quiz answers."""
    name: str = Field(max_length=100, default="Personality Archetype Quiz")
    peace_ans: str = Field(max_length=100)
    landscape_ans: str = Field(max_length=100)
    nightlife_ans: str = Field(max_length=100)
    motv_ans: str = Field(max_length=100)
    duration: int = Field(ge=1, le=30)
    price_range: str = Field(max_length=100)
    trip_desc: str | None = Field(default=None, max_length=500)


class QuizResponse(BaseModel):
    """Quiz data returned from API."""
    qid: int
    name: str
    peace_ans: str
    landscape_ans: str
    nightlife_ans: str
    motv_ans: str
    duration: int
    price_range: str
    trip_desc: str | None
    created_at: datetime
    uid: int

    model_config = {"from_attributes": True}
