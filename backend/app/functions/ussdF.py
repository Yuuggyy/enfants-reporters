from fastapi.responses import PlainTextResponse
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.ussdmodel import USSDSession
from app.schemas.ussdschema import USSDState

MAX_CHARS = 182  # limite imposée par la plupart des opérateurs


# ---------------------------------------------------------------------------
# Utilitaires
# ---------------------------------------------------------------------------
def _clean(text: str) -> str:
    return text.strip()


def _end(message: str) -> PlainTextResponse:
    """Termine la session USSD."""
    return PlainTextResponse(f"END {message}"[:MAX_CHARS])


def _con(message: str) -> PlainTextResponse:
    """Continue la session USSD (attend une réponse utilisateur)."""
    return PlainTextResponse(f"CON {message}"[:MAX_CHARS])


async def _get_session(
    db: AsyncSession,
    session_id: str,
    phone_number: str | None = None,
) -> USSDSession:
    result = await db.execute(
        select(USSDSession).where(USSDSession.session_id == session_id)
    )
    session = result.scalar_one_or_none()
    if not session:
        session = USSDSession(
            session_id=session_id,
            phone_number=phone_number or "INCONNU",
            state=USSDState.WELCOME.value,
            data={},
        )
        db.add(session)
        await db.flush()
    elif phone_number and session.phone_number != phone_number:
        # Met à jour si l'opérateur renvoie un numéro plus tard
        session.phone_number = phone_number
        await db.flush()

    return session
