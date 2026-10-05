# app/models/ussd.py
from datetime import datetime

from sqlalchemy import JSON, DateTime, Integer, String
from sqlalchemy.ext.mutable import MutableDict
from sqlalchemy.orm import Mapped, mapped_column

from ..db.session import Base


class USSDSession(Base):
    __tablename__ = "ussd_sessions"

    session_id: Mapped[str] = mapped_column(String(64), primary_key=True)
    phone_number: Mapped[str] = mapped_column(String(20), index=True)
    state: Mapped[str] = mapped_column(String(40), default="WELCOME")
    data: Mapped[dict] = mapped_column(
        MutableDict.as_mutable(JSON), default=dict
    )  # données accumulées
    step: Mapped[int] = mapped_column(Integer, default=0)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.now)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime, default=datetime.now, onupdate=datetime.now
    )
