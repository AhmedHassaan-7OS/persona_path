"""
PersonaPath — Application Settings

All settings are loaded from the .env file via pydantic-settings.
"""

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    # Database (Neon PostgreSQL)
    DB_URL: str

    # JWT
    JWT_SECRET: str
    JWT_ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    REFRESH_TOKEN_EXPIRE_DAYS: int = 7

    # Bcrypt
    BCRYPT_ROUNDS: int = 12

    # Redis
    REDIS_URL: str = "redis://localhost:6379/0"

    # Firebase (for verifying Google Sign-In tokens)
    FIREBASE_CREDENTIALS_PATH: str = "./firebase-service-account.json"

    # Gemini AI
    GEMINI_API_KEY: str = ""
    GEMINI_ENDPOINT: str = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"

    model_config = SettingsConfigDict(env_file=".env", extra="ignore")


config = Settings()