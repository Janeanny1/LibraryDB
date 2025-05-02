from sqlalchemy.orm import Session
from . import models, schemas

# Users CRUD
def get_user(db: Session, user_id: int):
    return db.query(models.User).filter(models.User.user_id == user_id).first()

def get_user_by_email(db: Session, email: str):
    return db.query(models.User).filter(models.User.email == email).first()

def get_users(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.User).offset(skip).limit(limit).all()

def create_user(db: Session, user: schemas.UserCreate):
    db_user = models.User(
        username=user.username,
        email=user.email,
        password=user.password
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def update_user(db: Session, user_id: int, user: schemas.UserUpdate):
    db_user = db.query(models.User).filter(models.User.user_id == user_id).first()
    if not db_user:
        return None
    
    update_data = user.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_user, key, value)
    
    db.commit()
    db.refresh(db_user)
    return db_user

def delete_user(db: Session, user_id: int):
    db_user = db.query(models.User).filter(models.User.user_id == user_id).first()
    if db_user:
        db.delete(db_user)
        db.commit()
        return True
    return False

# Tasks CRUD
def get_task(db: Session, task_id: int):
    return db.query(models.Task).filter(models.Task.task_id == task_id).first()

def get_tasks(db: Session, user_id: int, skip: int = 0, limit: int = 100):
    return db.query(models.Task).filter(models.Task.user_id == user_id)\
              .offset(skip).limit(limit).all()

def create_task(db: Session, task: schemas.TaskCreate):
    db_task = models.Task(
        user_id=task.user_id,
        title=task.title,
        description=task.description,
        status=task.status,
        priority=task.priority,
        due_date=task.due_date
    )
    db.add(db_task)
    db.commit()
    db.refresh(db_task)
    
    if task.category_ids:
        for category_id in task.category_ids:
            db.execute(
                models.task_category_association.insert().values(
                    task_id=db_task.task_id,
                    category_id=category_id
                )
            )
        db.commit()
    
    return db_task

def update_task(db: Session, task_id: int, task: schemas.TaskUpdate):
    db_task = get_task(db, task_id)
    if not db_task:
        return None
    
    for key, value in task.dict(exclude_unset=True, exclude={"category_ids"}).items():
        setattr(db_task, key, value)
    
    if task.category_ids is not None:
        db.execute(
            models.task_category_association.delete()\
                .where(models.task_category_association.c.task_id == task_id)
        )
        for category_id in task.category_ids:
            db.execute(
                models.task_category_association.insert().values(
                    task_id=task_id,
                    category_id=category_id
                )
            )
    
    db.commit()
    db.refresh(db_task)
    return db_task

def delete_task(db: Session, task_id: int):
    db_task = get_task(db, task_id)
    if not db_task:
        return False
    db.delete(db_task)
    db.commit()
    return True

# Categories CRUD
def get_category(db: Session, category_id: int):
    return db.query(models.Category).filter(models.Category.category_id == category_id).first()

def get_categories(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Category).offset(skip).limit(limit).all()

def create_category(db: Session, category: schemas.CategoryCreate):
    db_category = models.Category(**category.dict())
    db.add(db_category)
    db.commit()
    db.refresh(db_category)
    return db_category