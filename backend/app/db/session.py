# On importe AsyncGenerator pour le typage de notre dépendance de base de données.
from collections.abc import AsyncGenerator

from sqlalchemy.ext.asyncio import (  # La fabrique de sessions asynchrones; La fonction pour créer le moteur asynchrone
    AsyncSession,  # La classe de session asynchrone
    async_sessionmaker,
    create_async_engine,
)
from sqlalchemy.orm import DeclarativeBase

from ..core.config import settings

engine = create_async_engine(settings.DATABASE_URL, echo=True)

async_session = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)


class Base(DeclarativeBase):
    pass


# Cette fonction est une dépendance FastAPI. Elle sera appelée pour chaque requête.
async def get_db() -> AsyncGenerator[AsyncSession, None]:
    # On ouvre une nouvelle session de base de données.
    async with async_session() as session:
        # On donne la session à la route qui en a besoin.
        yield session
    # À la fin de la requête, la session est automatiquement fermée grâce au 'async with'.
