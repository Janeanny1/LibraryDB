from sqlalchemy import Column, Integer, String, Text, Enum, Date, TIMESTAMP, ForeignKey, Table
from sqlalchemy.orm import relationship
from .database import Base

task_category_association = Table(
    'task_categories', Base.metadata,
    Column('task_id', Integer, ForeignKey('tasks.task_id'), primary_key=True),
    Column('category_id', Integer, ForeignKey('categories.category_id'), primary_key=True)
)

class User(Base):
    __tablename__ = "users"
    
    user_id = Column(Integer, primary_key=True, index=True)
    username = Column(String(50), unique=True, nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    password = Column(String(255), nullable=False)
    created_at = Column(TIMESTAMP, server_default="CURRENT_TIMESTAMP")
    
    tasks = relationship("Task", back_populates="owner")

class Task(Base):
    __tablename__ = "tasks"
    
    task_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.user_id"), nullable=False)
    title = Column(String(100), nullable=False)
    description = Column(Text)
    status = Column(Enum('pending', 'in_progress', 'completed', name='task_status'), 
                   default='pending')
    priority = Column(Enum('low', 'medium', 'high', name='task_priority'), 
                     default='medium')
    due_date = Column(Date)
    created_at = Column(TIMESTAMP, server_default="CURRENT_TIMESTAMP")
    updated_at = Column(TIMESTAMP, server_default="CURRENT_TIMESTAMP", 
                       onupdate="CURRENT_TIMESTAMP")
    
    owner = relationship("User", back_populates="tasks")
    categories = relationship("Category", secondary=task_category_association, 
                             back_populates="tasks")

class Category(Base):
    __tablename__ = "categories"
    
    category_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(50), unique=True, nullable=False)
    description = Column(Text)
    
    tasks = relationship("Task", secondary=task_category_association, 
                        back_populates="categories")