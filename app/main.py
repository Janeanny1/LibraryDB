from fastapi import FastAPI
from .database import engine
from . import models
from .routers import tasks, users, categories

models.Base.metadata.create_all(bind=engine)

app = FastAPI()

app.include_router(tasks.router)
app.include_router(users.router)
app.include_router(categories.router)

@app.get("/")
def read_root():
    return {"message": "Task Manager API"}