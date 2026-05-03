"""
PersonaPath — Middleware Configuration

Registers CORS, trusted hosts, and request logging middleware.
"""

import time

from fastapi import FastAPI
from fastapi.requests import Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.trustedhost import TrustedHostMiddleware


def register_middleware(app: FastAPI):
    """Register all middleware on the FastAPI app."""

    @app.middleware("http")
    async def request_logging(request: Request, call_next):
        start = time.time()
        response = await call_next(request)
        elapsed = time.time() - start
        print(
            f"{request.client.host}:{request.client.port} — "
            f"{request.method} {request.url.path} — {elapsed:.3f}s"
        )
        return response

    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_methods=["GET", "POST", "PATCH", "DELETE", "OPTIONS"],
        allow_headers=["*"],
        allow_credentials=True,
    )

    app.add_middleware(
        TrustedHostMiddleware,
        allowed_hosts=["*"],
    )
