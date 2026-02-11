from decouple import config
from pydantic import BaseModel, Field
from sqlmodel import SQLModel, create_engine
from sqlalchemy.orm import sessionmaker

GREETINGS = config("GREETINGS")
DB_URL = config("DB_URL")
SECRET_KEY = config("SECRET_KEY")
DEBUG = config("DEBUG")
FRONTEND_API=config("FRONTEND_API")
if DB_URL is None:
    raise ValueError("DB_URL is not set in the environment variables.")

sync_engine = create_engine(DB_URL, echo=True, future=True)

localmaker =  sessionmaker(bind=sync_engine)

def init_db():
    SQLModel.metadata.create_all(sync_engine)


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
