"""
PersonaPath — Redis Client (Token Blacklist)

Used to blacklist JWT tokens on logout so they can't be reused.
"""

from redis.asyncio import Redis
from redis.exceptions import ConnectionError
from .config import config

# Create Redis client
token_blacklist = Redis.from_url(config.REDIS_URL, decode_responses=True)


async def check_redis_connection() -> bool:
    """Verify Redis is reachable on startup."""
    try:
        await token_blacklist.ping()
        print("[+] Redis connected")
        return True
    except ConnectionError as e:
        print(f"[-] Redis connection failed: {e}")
        return False


async def add_to_blacklist(jti: str, exp: int = 1800) -> bool:
    """Add a JWT ID to the blacklist with an expiration (seconds)."""
    try:
        result = await token_blacklist.set(name=jti, value="", ex=exp)
        if result:
            print(f"[+] Token blacklisted: {jti[:8]}...")
        return bool(result)
    except ConnectionError as e:
        print(f"[-] Redis error (add_to_blacklist): {e}")
        return False


async def check_blacklist(jti: str) -> bool:
    """Check if a JWT ID has been blacklisted."""
    try:
        result = await token_blacklist.get(name=jti)
        return result is not None
    except ConnectionError as e:
        print(f"[-] Redis error (check_blacklist): {e}")
        return False