"""
PersonaPath — AI Routes

Endpoints:
  POST /ai/generate — Generate a travel itinerary from quiz answers
"""

from fastapi import APIRouter, Depends, status
from fastapi.exceptions import HTTPException
from pydantic import BaseModel

from src.db.models import User
from src.auth.dependencies import get_current_user
from .service import generate_itinerary


ai_router = APIRouter()


class GenerateRequest(BaseModel):
    """Quiz answers to generate an itinerary from."""
    answers: dict


class GenerateResponse(BaseModel):
    """AI-generated itinerary."""
    title: str
    description: str
    days: list[str]
    activities: list[dict]


@ai_router.post("/generate", response_model=GenerateResponse)
async def generate(
    data: GenerateRequest,
    user: User = Depends(get_current_user),
):
    try:
        result = await generate_itinerary(data.answers)
        return GenerateResponse(
            title=result.get("title", "My Journey"),
            description=result.get("description", ""),
            days=result.get("days", []),
            activities=result.get("activities", []),
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail=f"AI generation failed: {str(e)}",
        )
