
from sqlalchemy.orm import sessionmaker
from sqlmodel import SQLModel, create_engine
from src.logger import logger
from decouple import config

DATABASE_URL = config("APP_DB_URL")

if DATABASE_URL is None:
    raise ValueError("DATABASE_URL is not set in the environment variables.")

# sync engine for celery and etl tasks
sync_engine = create_engine(DATABASE_URL, echo=True, future=True)


LocalSessionMaker = sessionmaker(
    bind=sync_engine,
)


def initialize_db():
    try:
        SQLModel.metadata.create_all(sync_engine)
        logger.info("database initialized")
    except Exception as e:
        logger.error(f"Error initializing database: {e}")


def get_sync_db():
    logger.debug("Opening sync DB session")
    db = LocalSessionMaker()
    try:
        yield db
    finally:
        db.close()
        logger.debug("Sync DB session closed")

