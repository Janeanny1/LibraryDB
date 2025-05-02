from pydantic import BaseModel, EmailStr
from datetime import date
from typing import Optional, List

class UserBase(BaseModel):
    username: str
    email: EmailStr

class UserCreate(UserBase):
    password: str

class User(UserBase):
    user_id: int
    
    class Config:
        from_attributes = True 

class UserUpdate(BaseModel):
    username: Optional[str] = None
    email: Optional[EmailStr] = None
    password: Optional[str] = None

class TaskBase(BaseModel):
    title: str
    description: Optional[str] = None
    status: Optional[str] = 'pending'
    priority: Optional[str] = 'medium'
    due_date: Optional[date] = None

class TaskCreate(TaskBase):
    user_id: int
    category_ids: Optional[List[int]] = None

class TaskUpdate(TaskBase):
    category_ids: Optional[List[int]] = None

class Task(TaskBase):
    task_id: int
    user_id: int
    created_at: str
    updated_at: str
    categories: List['Category'] = []
    
    class Config:
        from_attributes = True  

class CategoryBase(BaseModel):
    name: str
    description: Optional[str] = None

class CategoryCreate(CategoryBase):
    pass

class Category(CategoryBase):
    category_id: int
    
    class Config:
        from_attributes = True  