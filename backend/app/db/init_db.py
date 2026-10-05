from sqlalchemy import select

from ..core.security import get_password_hash
from ..models.models import Admin, Club, Encadreur
from .data.club import clubs_data
from .data.encadreurs import encadreurs_data
from .session import async_session


async def init_db():
    async with async_session() as db:
        # 1. Précréation de l'Administrateur National UNICEF
        stmt = select(Admin).where(Admin.email == "admin@unicef.cd")
        result = await db.execute(stmt)
        admin = result.scalars().first()

        if not admin:
            admin = Admin(
                id="ADM-UNICEF-01",
                email="admin@unicef.cd",
                hashed_password=get_password_hash("AdminUnicef2026!"),
                prenom="Superviseur",
                nom="UNICEF National",
                section="UNICEF C&A (Communication & Plaidoyer / T4D)",
                role_titre="Administrateur National",
                is_active=True,
            )
            db.add(admin)

        for enc_data in encadreurs_data:
            enc = (
                (
                    await db.execute(
                        select(Encadreur).where(Encadreur.id == enc_data["id"])
                    )
                )
                .scalars()
                .first()
            )
            if not enc:
                enc = Encadreur(
                    id=enc_data["id"],
                    email=enc_data["email"],
                    hashed_password=get_password_hash(enc_data["password"]),
                    prenom=enc_data["prenom"],
                    nom=enc_data["nom"],
                    telephone=enc_data["telephone"],
                    organisation=enc_data["organisation"],
                    province=enc_data["province"],
                    ville=enc_data["ville"],
                    territoire=enc_data["territoire"],
                    is_active=True,
                )
                db.add(enc)

        await db.flush()

        for c_data in clubs_data:
            c = (
                (await db.execute(select(Club).where(Club.id == c_data["id"])))
                .scalars()
                .first()
            )
            if not c:
                c = Club(
                    id=c_data["id"],
                    nom=c_data["nom"],
                    province=c_data["province"],
                    ville=c_data["ville"],
                    encadreur_id=c_data["encadreur_id"],
                )
                db.add(c)

        await db.flush()

        # Structure prête sans données d'adolescents mockées
        await db.commit()
