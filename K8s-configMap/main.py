from fastapi import FastAPI
from config import settings, EnvResponse
app = FastAPI()

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