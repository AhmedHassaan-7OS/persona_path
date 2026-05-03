"""
PersonaPath — FastAPI Application Entry Point
"""

from fastapi import FastAPI
from contextlib import asynccontextmanager

from src.db.main import init_db
from src.db.redis import check_redis_connection
from src.auth.firebase_verify import init_firebase
from src.auth.routes import auth_router
from src.quiz.routes import quiz_router
from src.itinerary.routes import itinerary_router
from src.ai.routes import ai_router
from src.middleware import register_middleware
from src.errors import register_error_handlers


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Startup and shutdown logic."""
    print("[+] PersonaPath server starting...")
    await init_db()
    await check_redis_connection()
    init_firebase()
    yield
    print("[-] PersonaPath server stopped")


version = "v1"

app = FastAPI(
    title="PersonaPath API",
    description="Travel personality & itinerary service",
    version=version,
    lifespan=lifespan,
    docs_url=f"/api/{version}/docs",
    redoc_url=f"/api/{version}/redocs",
)

# Register middleware and error handlers
register_middleware(app)
register_error_handlers(app)

# Register routers
app.include_router(auth_router, prefix=f"/api/{version}/auth", tags=["auth"])
app.include_router(quiz_router, prefix=f"/api/{version}/quiz", tags=["quiz"])
app.include_router(itinerary_router, prefix=f"/api/{version}/itinerary", tags=["itinerary"])
app.include_router(ai_router, prefix=f"/api/{version}/ai", tags=["ai"])


@app.get("/")
async def root():
    return {"message": "PersonaPath API is running", "docs": f"/api/{version}/docs"}
