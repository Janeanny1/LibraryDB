from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from .. import schemas, crud
from ..database import get_db

router = APIRouter(prefix="/tasks", tags=["tasks"])

@router.post("/", response_model=schemas.Task)
def create_task(task: schemas.TaskCreate, db: Session = Depends(get_db)):
   
    db_user = crud.get_user(db, user_id=task.user_id)
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    
    if task.category_ids:
        for category_id in task.category_ids:
            db_category = crud.get_category(db, category_id=category_id)
            if not db_category:
                raise HTTPException(status_code=404, detail=f"Category {category_id} not found")
    
    return crud.create_task(db=db, task=task)

@router.get("/", response_model=List[schemas.Task])
def read_tasks(user_id: int, skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    tasks = crud.get_tasks(db, user_id=user_id, skip=skip, limit=limit)
    return tasks

@router.get("/{task_id}", response_model=schemas.Task)
def read_task(task_id: int, db: Session = Depends(get_db)):
    db_task = crud.get_task(db, task_id=task_id)
    if db_task is None:
        raise HTTPException(status_code=404, detail="Task not found")
    return db_task

@router.put("/{task_id}", response_model=schemas.Task)
def update_task(task_id: int, task: schemas.TaskUpdate, db: Session = Depends(get_db)):
    db_task = crud.update_task(db=db, task_id=task_id, task=task)
    if db_task is None:
        raise HTTPException(status_code=404, detail="Task not found")
    return db_task

@router.delete("/{task_id}")
def delete_task(task_id: int, db: Session = Depends(get_db)):
    if not crud.delete_task(db=db, task_id=task_id):
        raise HTTPException(status_code=404, detail="Task not found")
    return {"message": "Task deleted successfully"}




