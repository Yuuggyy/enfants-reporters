import os
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(case_sensitive=True)

    PROJECT_NAME: str = "BanApp - Plateforme Engagement Adolescents & Enfants Reporters RDC"
    VERSION: str = "1.0.0"
    API_V1_STR: str = "/api/v1"
    
    # Sécurité & JWT
    SECRET_KEY: str = os.getenv("SECRET_KEY", "unicef_rdc_secret_key_jwt_engagement_ados_2026_super_secure")
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7  # 7 jours
    
    # Base de données (SQLite par défaut, compatible PostgreSQL)
    DATABASE_URL: str = os.getenv("DATABASE_URL", "sqlite:///./unicef_ados.db")
    
    # Interopérabilité UNICEF
    RAPIDPRO_API_URL: str = os.getenv("RAPIDPRO_API_URL", "https://rapidpro.unicef.org/api/v2")
    RAPIDPRO_API_TOKEN: str = os.getenv("RAPIDPRO_API_TOKEN", "mock_rapidpro_api_token_unicef_2026")
    
    WORDPRESS_PONABANA_URL: str = os.getenv("WORDPRESS_PONABANA_URL", "https://ponabana.unicef.cd/wp-json/wp/v2")
    WORDPRESS_APP_USER: str = os.getenv("WORDPRESS_APP_USER", "ponabana_api_user")
    WORDPRESS_APP_PASSWORD: str = os.getenv("WORDPRESS_APP_PASSWORD", "mock_app_password_wp_2026")
    
    KOBOTOOLBOX_API_URL: str = os.getenv("KOBOTOOLBOX_API_URL", "https://kobo.humanitarianresponse.info/api/v2")
    
    # Contacts d'urgence sauvegarde PSE UNICEF RDC
    PSE_EMERGENCY_EMAIL: str = "pse.safeguarding@unicef.org"
    PSE_EMERGENCY_PHONE: str = "+243810000000"

settings = Settings()
