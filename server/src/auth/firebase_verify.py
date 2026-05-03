"""
PersonaPath — Firebase Token Verification

Verifies Firebase ID tokens sent by Flutter clients who signed in
with Google. The server uses these to create/find users in PostgreSQL.
"""

import firebase_admin
from firebase_admin import auth as firebase_auth, credentials
from src.db.config import config

_firebase_app = None


def init_firebase():
    """Initialize Firebase Admin SDK (call once on startup)."""
    global _firebase_app
    if _firebase_app is not None:
        return

    cred_path = config.FIREBASE_CREDENTIALS_PATH
    if not cred_path:
        print("[!] FIREBASE_CREDENTIALS_PATH not set -- Google Sign-In verification disabled")
        return

    try:
        cred = credentials.Certificate(cred_path)
        _firebase_app = firebase_admin.initialize_app(cred)
        print("[+] Firebase Admin SDK initialized")
    except Exception as e:
        print(f"[-] Firebase Admin SDK init failed: {e}")


def verify_firebase_token(id_token: str) -> dict | None:
    """
    Verify a Firebase ID token and return user info.

    Returns dict with keys: firebase_uid, email, name, picture
    Returns None if verification fails.
    """
    if _firebase_app is None:
        raise ValueError("Firebase Admin SDK not initialized")

    try:
        decoded = firebase_auth.verify_id_token(id_token)
        return {
            "firebase_uid": decoded["uid"],
            "email": decoded.get("email", ""),
            "name": decoded.get("name", ""),
            "picture": decoded.get("picture", ""),
        }
    except firebase_auth.ExpiredIdTokenError:
        print("[-] Firebase token expired")
        return None
    except firebase_auth.InvalidIdTokenError:
        print("[-] Firebase token invalid")
        return None
    except Exception as e:
        print(f"[-] Firebase token verification error: {e}")
        return None
