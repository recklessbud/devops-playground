from fastapi import FastAPI, Request, HTTPException, status
from loguru import logger
import sys
import time
from prometheus_fastapi_instrumentator import Instrumentator


# Remove default logger and configure for JSON output
logger.remove()

# Log to stdout as JSON (Promtail will scrape this via Docker)
logger.add(
    sys.stdout,
    format="{time:YYYY-MM-DD HH:mm:ss} | {level} | {name}:{function}:{line} | {message}",
    level="INFO",
    serialize=True   # 👈 outputs as JSON — makes Grafana queries much easier
)

# Also write to file (optional, if you want file-based scraping)
logger.add(
    "/var/log/myapp/app.log",
    rotation="10 MB",       # new file every 10MB
    retention="7 days",     # keep 7 days of logs
    level="INFO",
    serialize=True
)

app = FastAPI()

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


@app.get("/items/{item_id}")
def get_item(item_id: int):
    if item_id == 0:
        logger.error("Invalid item_id=0 requested")
        return {"error": "invalid id"}
    logger.info(f"Fetching item {item_id}")
    return {"item_id": item_id}


@app.get("/health")
def health():
    logger.debug("Health check")
    return {"status": "ok"}


@app.get("/error", status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
def error():
    logger.error("Error endpoint hit")
    raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Internal Server Error")