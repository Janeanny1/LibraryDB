# Task Manager API

# Description
A RESTful API for managing tasks, users, and categories built with FastAPI and SQLAlchemy. This API allows users to:

- Create, read, update, and delete users
- Create, read, update, and delete tasks with status, priority, and due dates
- Organize tasks into categories
- Associate multiple categories with each task
- The API follows REST principles and provides proper error handling and validation.

# Setup Instructions
## Prerequisites
* Python 
* MySQL server
* pip package manager

# Installation
* Clone the repository:
* git clone https://github.com/Janeanny1/LibraryDB.git
* cd task-manager-api

# Create and activate a virtual environment:
+ python -m venv venv
+ source venv/bin/activate  
+ #On Windows use `venv\Scripts\activate`

# Install dependencies:
+ pip install -r requirements.txt

# Set up the database:
- Create a MySQL database named task_manager
- Import the database schema from task_manager.sql
- Update the database connection URL in database.py with your credentials:
- SQLALCHEMY_DATABASE_URL = "mysql+mysqlconnector://username:password@localhost/task_manager"

# Run the application:
- uvicorn app.main:app --reload
- The API will be available at http://127.0.0.1:8000. You can access the interactive API documentation at http://127.0.0.1:8000/docs.

# Database Schema (ERD)

![ERD drawio (4)](https://github.com/user-attachments/assets/4eb6795e-d6b0-4ddc-987b-2d6e6219c2e9)

# API Endpoints
## Users
- POST /users/ - Create a new user
- GET /users/ - Get list of users
- GET /users/{user_id} - Get a specific user
- PUT /users/{user_id} - Update a user
- DELETE /users/{user_id} - Delete a user

## Tasks
* POST /tasks/ - Create a new task
* GET /tasks/ - Get tasks for a specific user
* GET /tasks/{task_id} - Get a specific task
* PUT /tasks/{task_id} - Update a task
* DELETE /tasks/{task_id} - Delete a task

## Categories
* POST /categories/ - Create a new category
* GET /categories/ - Get list of categories
* GET /categories/{category_id} - Get a specific category

# License
- This project is licensed under the MIT License. See the LICENSE file for details.

# Contact
* GitHub: @Janeanny1

💻Happy coding!
