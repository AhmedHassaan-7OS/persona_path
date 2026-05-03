"""
PersonaPath — AI Service

Calls Google Gemini API to generate personalized travel itineraries
based on the user's quiz answers.
"""

import json
import logging

import httpx

from src.db.config import config


ITINERARY_PROMPT = (
    "You are a professional travel expert. Use the quiz answers to create a "
    "personalized itinerary. Return ONLY valid JSON with this exact shape: "
    '{"title": "...", "description": "...", "days": ["Day 1...", "Day 2..."], '
    '"activities": [{"day":"Day 1","time":"09:00","title":"...","note":"..."}]}. '
    "Do not include any extra text, markdown, or explanations. "
    "Answers: {answers}"
)


async def generate_itinerary(answers: dict) -> dict:
    """
    Call Gemini API with quiz answers and return parsed itinerary JSON.

    Args:
        answers: Quiz answer data from the client.

    Returns:
        Parsed itinerary dict with keys: title, description, days, activities.

    Raises:
        Exception if AI call fails or response can't be parsed.
    """
    api_key = config.GEMINI_API_KEY
    endpoint = config.GEMINI_ENDPOINT

    if not api_key or not endpoint:
        logging.warning("Gemini API not configured — returning mock itinerary")
        return _mock_itinerary(answers)

    # Build the prompt
    prompt = ITINERARY_PROMPT.replace("{answers}", json.dumps(answers))

    # Build the request URL with API key
    url = endpoint
    if "?" in url:
        url += f"&key={api_key}"
    else:
        url += f"?key={api_key}"

    # Build the request body (Gemini format)
    body = {
        "contents": [
            {
                "parts": [
                    {"text": prompt},
                ],
            },
        ],
    }

    async with httpx.AsyncClient(timeout=30.0) as client:
        response = await client.post(
            url,
            json=body,
            headers={"Content-Type": "application/json"},
        )

    if response.status_code < 200 or response.status_code >= 300:
        logging.error(f"Gemini API error: {response.status_code} — {response.text}")
        raise Exception(f"AI request failed with status {response.status_code}")

    # Parse the response
    decoded = response.json()
    return _extract_itinerary(decoded)


def _extract_itinerary(decoded: dict) -> dict:
    """Extract itinerary JSON from Gemini API response."""
    try:
        candidates = decoded.get("candidates", [])
        if candidates:
            content = candidates[0].get("content", {})
            parts = content.get("parts", [])
            if parts:
                text = parts[0].get("text", "")
                if text:
                    cleaned = _clean_json(text)
                    return json.loads(cleaned)
    except (json.JSONDecodeError, KeyError, IndexError) as e:
        logging.error(f"Failed to parse Gemini response: {e}")

    raise Exception("Could not parse AI response into valid itinerary JSON")


def _clean_json(text: str) -> str:
    """Strip markdown code fences from Gemini output."""
    cleaned = text.strip()
    if cleaned.startswith("```"):
        cleaned = cleaned.replace("```json", "").replace("```", "").strip()
    return cleaned


def _mock_itinerary(answers: dict) -> dict:
    """Fallback itinerary when AI is not configured."""
    return {
        "title": "Cairo & Alexandria Escape",
        "description": "A relaxed 5-day plan that mixes history, food, and sea views.",
        "days": [
            "Day 1: Old Cairo",
            "Day 2: The Pyramids",
            "Day 3: Alexandria Coast",
            "Day 4: Museums & Cafes",
            "Day 5: Markets & Souvenirs",
        ],
        "activities": [
            {"day": "Day 1", "time": "09:00", "title": "Khan El-Khalili", "note": "Start with a calm walk."},
            {"day": "Day 2", "time": "10:00", "title": "Giza Plateau", "note": "Sunrise photos & camel ride."},
            {"day": "Day 3", "time": "12:00", "title": "Corniche", "note": "Sea breeze lunch."},
            {"day": "Day 4", "time": "15:00", "title": "Egyptian Museum", "note": "History and art."},
            {"day": "Day 5", "time": "18:00", "title": "Local Market", "note": "Find unique gifts."},
        ],
    }
