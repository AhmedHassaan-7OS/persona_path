"""
PersonaPath — Itinerary Pydantic Schemas
"""

from pydantic import BaseModel, Field
from datetime import datetime


class ItineraryCreate(BaseModel):
    """Request to save an itinerary."""
    name: str = Field(max_length=100)
    description: str | None = Field(default=None, max_length=500)
    itinerary_content: str  # JSON string of the full itinerary
    qid: int | None = None  # Optional link to the quiz that generated it


class ItineraryUpdate(BaseModel):
    """Request to update an itinerary name."""
    name: str = Field(min_length=1, max_length=100)


class ItineraryResponse(BaseModel):
    """Itinerary data returned from API."""
    tid: int
    name: str
    description: str | None
    itinerary_content: str
    created_at: datetime
    qid: int | None
    uid: int

    model_config = {"from_attributes": True}


class DashboardResponse(BaseModel):
    """User dashboard stats."""
    uid: int
    username: str
    email: str
    member_since: datetime
    total_quizzes: int
    total_itineraries: int


class ActivityResponse(BaseModel):
    """A single activity item (quiz or itinerary)."""
    activity_id: int
    activity_name: str
    created_at: datetime
    uid: int
    activity_type: str  # "quiz" or "itinerary"
