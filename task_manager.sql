-- Task Manager Database
CREATE DATABASE task_manager;
USE task_manager;

-- Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tasks table
CREATE TABLE tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    status ENUM('pending', 'in_progress', 'completed') DEFAULT 'pending',
    priority ENUM('low', 'medium', 'high') DEFAULT 'medium',
    due_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Categories table
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

-- Task-Category relationship (many-to-many)
CREATE TABLE task_categories (
    task_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (task_id, category_id),
    FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE
);

-- Insert sample data
INSERT INTO users (username, email, password) VALUES
('jamesmo', 'jmo@example.com', '$2b$22$ZixE'),
('janelio', 'jane@example.com', '$2b$12$EixZ');

INSERT INTO categories (name, description) VALUES
('work', 'Tasks related to professional work'),
('personal', 'Personal tasks and errands'),
('health', 'Health and fitness related tasks');

INSERT INTO tasks (user_id, title, description, status, priority, due_date) VALUES
(1, 'Complete project report', 'Finish the quarterly report for the client', 'in_progress', 'high', '2023-06-15'),
(1, 'Buy groceries', 'Milk, eggs, bread, and vegetables', 'pending', 'medium', '2023-06-10'),
(2, 'Doctor appointment', 'Annual checkup with Dr. Smith', 'completed', 'high', '2023-06-05'),
(2, 'Gym session', '1 hour cardio and weights', 'pending', 'low', NULL);

INSERT INTO task_categories (task_id, category_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 3);