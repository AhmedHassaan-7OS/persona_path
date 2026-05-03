"""
PersonaPath — Itinerary Service

CRUD operations for the Itinerary model + dashboard/activity queries.
"""

from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select, func
from sqlalchemy import union_all, literal_column

from src.db.models import Itinerary, Quiz, User
from .schema import ItineraryCreate


class ItineraryService:

    async def create_itinerary(
        self, data: ItineraryCreate, uid: int, session: AsyncSession
    ) -> Itinerary:
        """Save a new itinerary for the given user."""
        itinerary = Itinerary(
            name=data.name,
            description=data.description,
            itinerary_content=data.itinerary_content,
            qid=data.qid,
            uid=uid,
        )
        session.add(itinerary)
        await session.commit()
        await session.refresh(itinerary)
        return itinerary

    async def get_itineraries_by_user(
        self, uid: int, session: AsyncSession
    ) -> list[Itinerary]:
        """Get all itineraries for a user, newest first."""
        statement = (
            select(Itinerary)
            .where(Itinerary.uid == uid)
            .order_by(Itinerary.created_at.desc())
        )
        result = await session.execute(statement)
        return list(result.scalars().all())

    async def get_itinerary_by_id(
        self, tid: int, session: AsyncSession
    ) -> Itinerary | None:
        """Get a single itinerary by ID."""
        statement = select(Itinerary).where(Itinerary.tid == tid)
        result = await session.execute(statement)
        return result.scalar_one_or_none()

    async def update_itinerary_name(
        self, tid: int, uid: int, new_name: str, session: AsyncSession
    ) -> Itinerary | None:
        """Update an itinerary's name (only if owned by the user)."""
        statement = select(Itinerary).where(
            Itinerary.tid == tid, Itinerary.uid == uid
        )
        result = await session.execute(statement)
        itinerary = result.scalar_one_or_none()

        if not itinerary:
            return None

        itinerary.name = new_name
        await session.commit()
        await session.refresh(itinerary)
        return itinerary

    async def delete_itinerary(
        self, tid: int, uid: int, session: AsyncSession
    ) -> bool:
        """Delete an itinerary (only if owned by the user)."""
        statement = select(Itinerary).where(
            Itinerary.tid == tid, Itinerary.uid == uid
        )
        result = await session.execute(statement)
        itinerary = result.scalar_one_or_none()

        if not itinerary:
            return False

        await session.delete(itinerary)
        await session.commit()
        return True

    async def get_dashboard(self, uid: int, session: AsyncSession) -> dict:
        """
        Get dashboard stats for a user.
        Equivalent to the vw_user_dashboard SQL view.
        """
        user_stmt = select(User).where(User.uid == uid)
        user_result = await session.execute(user_stmt)
        user = user_result.scalar_one_or_none()

        if not user:
            return None

        quiz_count_stmt = select(func.count(Quiz.qid)).where(Quiz.uid == uid)
        quiz_result = await session.execute(quiz_count_stmt)
        total_quizzes = quiz_result.scalar() or 0

        itin_count_stmt = select(func.count(Itinerary.tid)).where(Itinerary.uid == uid)
        itin_result = await session.execute(itin_count_stmt)
        total_itineraries = itin_result.scalar() or 0

        return {
            "uid": user.uid,
            "username": user.username,
            "email": user.email,
            "member_since": user.created_at,
            "total_quizzes": total_quizzes,
            "total_itineraries": total_itineraries,
        }

    async def get_all_activity(self, uid: int, session: AsyncSession) -> list[dict]:
        """
        Get all activity (quizzes + itineraries) for a user, newest first.
        Equivalent to the vw_all_activity SQL view.
        """
        # Get quizzes
        quiz_stmt = (
            select(Quiz.qid, Quiz.name, Quiz.created_at)
            .where(Quiz.uid == uid)
        )
        quiz_result = await session.execute(quiz_stmt)
        quizzes = quiz_result.all()

        # Get itineraries
        itin_stmt = (
            select(Itinerary.tid, Itinerary.name, Itinerary.created_at)
            .where(Itinerary.uid == uid)
        )
        itin_result = await session.execute(itin_stmt)
        itineraries = itin_result.all()

        # Merge and sort
        activities = []
        for q in quizzes:
            activities.append({
                "activity_id": q.qid,
                "activity_name": q.name,
                "created_at": q.created_at,
                "uid": uid,
                "activity_type": "quiz",
            })
        for i in itineraries:
            activities.append({
                "activity_id": i.tid,
                "activity_name": i.name,
                "created_at": i.created_at,
                "uid": uid,
                "activity_type": "itinerary",
            })

        activities.sort(key=lambda x: x["created_at"], reverse=True)
        return activities
