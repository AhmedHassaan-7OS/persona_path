"""
PersonaPath — Quiz Service

CRUD operations for the Quiz model.
"""

from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select

from src.db.models import Quiz
from .schema import QuizCreate


class QuizService:

    async def create_quiz(self, data: QuizCreate, uid: int, session: AsyncSession) -> Quiz:
        """Save a new quiz for the given user."""
        quiz = Quiz(
            name=data.name,
            peace_ans=data.peace_ans,
            landscape_ans=data.landscape_ans,
            nightlife_ans=data.nightlife_ans,
            motv_ans=data.motv_ans,
            duration=data.duration,
            price_range=data.price_range,
            trip_desc=data.trip_desc,
            uid=uid,
        )
        session.add(quiz)
        await session.commit()
        await session.refresh(quiz)
        return quiz

    async def get_quizzes_by_user(self, uid: int, session: AsyncSession) -> list[Quiz]:
        """Get all quizzes for a user, newest first."""
        statement = (
            select(Quiz)
            .where(Quiz.uid == uid)
            .order_by(Quiz.created_at.desc())
        )
        result = await session.execute(statement)
        return list(result.scalars().all())

    async def get_quiz_by_id(self, qid: int, session: AsyncSession) -> Quiz | None:
        """Get a single quiz by ID."""
        statement = select(Quiz).where(Quiz.qid == qid)
        result = await session.execute(statement)
        return result.scalar_one_or_none()

    async def delete_quiz(self, qid: int, uid: int, session: AsyncSession) -> bool:
        """Delete a quiz (only if owned by the user)."""
        statement = select(Quiz).where(Quiz.qid == qid, Quiz.uid == uid)
        result = await session.execute(statement)
        quiz = result.scalar_one_or_none()

        if not quiz:
            return False

        await session.delete(quiz)
        await session.commit()
        return True
