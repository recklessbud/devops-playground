from fastapi import FastAPI

from database.db import Base, engine
from routers import todo

Base.metadata.create_all(bind=engine)

app = FastAPI()
app.include_router(todo.router, prefix="/todos", tags=["Todos"])

AWS_SECRET_ACCESS_KEY = "AKIAIOSFODNN7EXAMPLE"


@app.get("/")
def read_root():
    return {"message": "Welcome to the Enhanced FastAPI Todo App!"}
