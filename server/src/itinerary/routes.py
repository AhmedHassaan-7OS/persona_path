"""
PersonaPath — Itinerary Routes

Endpoints:
  POST   /itinerary            — Save itinerary
  GET    /itinerary            — Get all itineraries for current user
  GET    /itinerary/dashboard  — Get user dashboard stats
  GET    /itinerary/activity   — Get all activity history
  GET    /itinerary/{tid}      — Get specific itinerary
  PATCH  /itinerary/{tid}      — Update itinerary name
  DELETE /itinerary/{tid}      — Delete itinerary
"""

from fastapi import APIRouter, Depends, status
from fastapi.exceptions import HTTPException
from sqlmodel.ext.asyncio.session import AsyncSession

from src.db.main import get_session
from src.db.models import User
from src.auth.dependencies import get_current_user

from .schema import (
    ItineraryCreate,
    ItineraryUpdate,
    ItineraryResponse,
    DashboardResponse,
    ActivityResponse,
)
from .service import ItineraryService


itinerary_router = APIRouter()
itinerary_service = ItineraryService()


@itinerary_router.post(
    "/", response_model=ItineraryResponse, status_code=status.HTTP_201_CREATED
)
async def save_itinerary(
    data: ItineraryCreate,
    user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
):
    itinerary = await itinerary_service.create_itinerary(data, user.uid, session)
    return itinerary


@itinerary_router.get("/", response_model=list[ItineraryResponse])
async def get_my_itineraries(
    user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
):
    return await itinerary_service.get_itineraries_by_user(user.uid, session)


@itinerary_router.get("/dashboard", response_model=DashboardResponse)
async def get_dashboard(
    user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
):
    dashboard = await itinerary_service.get_dashboard(user.uid, session)
    if not dashboard:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
        )
    return dashboard


@itinerary_router.get("/activity", response_model=list[ActivityResponse])
async def get_all_activity(
    user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
):
    return await itinerary_service.get_all_activity(user.uid, session)


@itinerary_router.get("/{tid}", response_model=ItineraryResponse)
async def get_itinerary(
    tid: int,
    user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
):
    itinerary = await itinerary_service.get_itinerary_by_id(tid, session)
    if not itinerary:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Itinerary not found",
        )
    # Ensure the user owns this itinerary
    if itinerary.uid != user.uid:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access denied",
        )
    return itinerary


@itinerary_router.patch("/{tid}", response_model=ItineraryResponse)
async def update_itinerary(
    tid: int,
    data: ItineraryUpdate,
    user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
):
    itinerary = await itinerary_service.update_itinerary_name(
        tid, user.uid, data.name, session
    )
    if not itinerary:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Itinerary not found",
        )
    return itinerary


@itinerary_router.delete("/{tid}")
async def delete_itinerary(
    tid: int,
    user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
):
    success = await itinerary_service.delete_itinerary(tid, user.uid, session)
    if not success:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Itinerary not found",
        )
    return {"message": "Itinerary deleted successfully"}
