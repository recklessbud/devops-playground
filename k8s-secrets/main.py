from fastapi import FastAPI
from config import settings, EnvResponse, init_db as initialize_db


async def lifespan(app: FastAPI):
    print("Starting up...")
    try:
        initialize_db()
        print("Database connected")
    except Exception as e:
        print(f"Error initializing database: {e}")
    yield
    print("Shutting down...")


app = FastAPI(lifespan=lifespan)

@app.get("/")
def root():
    return {"message": "give me money"}

@app.get('/api/env', response_model=EnvResponse)
def printEnv():
    return {
        "GREETINGS": settings.GREETINGS,
        "DB_URL": settings.DB_URL,
        "SECRET_KEY": settings.SECRET_KEY,
        "DEBUG": settings.DEBUG,
    } 