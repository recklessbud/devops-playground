from fastapi import FastAPI, Request, HTTPException, status, Depends
import time
from prometheus_fastapi_instrumentator import Instrumentator
from src.logger import logger
from src.config import get_sync_db, initialize_db
from src.models import Book
from sqlmodel import Session, select


# Remove default logger and configure for JSON output

def lifespan(app: FastAPI):
    logger.info("Starting up...")
    try:
        initialize_db()
        logger.info("Database connected")
    except Exception as e:
        logger.error(f"Error initializing database: {e}")
    yield
    logger.info("Shutting down...")


app = FastAPI(lifespan=lifespan)

Instrumentator().instrument(app).expose(app)


# Middleware to log every request automatically
@app.middleware("http")
async def log_requests(request: Request, call_next):
    start = time.time()
    response = await call_next(request)
    duration = time.time() - start

    logger.info(
        "request",
        extra={
            "method": request.method,
            "path": request.url.path,
            "status_code": response.status_code,
            "duration_ms": round(duration * 1000, 2),
            "client_ip": request.client.host,
        }
    )
    return response


@app.get("/")
def root():
    logger.info("Root endpoint hit")
    return {"message": "hello"}



@app.get("/health")
def health():
    logger.debug("Health check")
    return {"status": "ok"}


@app.get("/error", status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
def error():
    logger.error("Error endpoint hit")
    raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Internal Server Error")


@app.get("/books")
def get_books(db: Session = Depends(get_sync_db)):
        results = db.execute(select(Book))
        return results.scalars().all()



@app.post("/books")
def create_book(book: Book, db: Session = Depends(get_sync_db)):
    db.add(book)
    db.commit()
    db.refresh(book)
    return book