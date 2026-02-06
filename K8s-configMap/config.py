from decouple import config
from pydantic import BaseModel, Field


GREETINGS = config("GREETINGS")
DB_URL = config("DB_URL")
SECRET_KEY = config("SECRET_KEY")
DEBUG = config("DEBUG")

class Settings(BaseModel):
    GREETINGS: str = GREETINGS
    DB_URL: str = DB_URL
    SECRET_KEY: str = SECRET_KEY
    DEBUG: bool = DEBUG


settings = Settings()

class EnvResponse(BaseModel):
    GREETINGS: str
    DB_URL: str
    SECRET_KEY: str
    DEBUG: bool
