"""
PersonaPath — Quiz Routes

Endpoints:
  POST   /quiz       — Save quiz answers
  GET    /quiz       — Get all quizzes for current user
  DELETE /quiz/{qid} — Delete a quiz
"""

from fastapi import APIRouter, Depends, status
from fastapi.exceptions import HTTPException
from sqlmodel.ext.asyncio.session import AsyncSession

from src.db.main import get_session
from src.db.models import User
from src.auth.dependencies import get_current_user

from .schema import QuizCreate, QuizResponse
from .service import QuizService


quiz_router = APIRouter()
quiz_service = QuizService()


@quiz_router.post("/", response_model=QuizResponse, status_code=status.HTTP_201_CREATED)
async def save_quiz(
    data: QuizCreate,
    user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
):
    quiz = await quiz_service.create_quiz(data, user.uid, session)
    return quiz


@quiz_router.get("/", response_model=list[QuizResponse])
async def get_my_quizzes(
    user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
):
    return await quiz_service.get_quizzes_by_user(user.uid, session)


@quiz_router.delete("/{qid}")
async def delete_quiz(
    qid: int,
    user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
):
    success = await quiz_service.delete_quiz(qid, user.uid, session)
    if not success:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Quiz not found",
        )
    return {"message": "Quiz deleted successfully"}
