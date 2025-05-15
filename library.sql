-- Library Management System Database with Enhanced Relationships
CREATE DATABASE library_db;
USE library_db;

-- Authors Table (1:M with Books)
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    bio TEXT,
    birth_date DATE,
    nationality VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uc_author_name UNIQUE (name, birth_date)
);

-- Publishers Table (1:M with Books)
CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    address TEXT,
    contact_email VARCHAR(100),
    phone VARCHAR(20)
);

-- Books Table (M:M with Members through Loans)
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author_id INT NOT NULL,
    publisher_id INT,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    edition VARCHAR(10),
    publication_year YEAR,
    genre VARCHAR(50),
    total_copies INT NOT NULL DEFAULT 1,
    available_copies INT NOT NULL DEFAULT 1,
    shelf_location VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE RESTRICT,
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id) ON DELETE SET NULL,
    CONSTRAINT chk_copies CHECK (available_copies <= total_copies AND available_copies >= 0)
);

-- Members Table (1:1 with LibraryCards, 1:M with Loans)
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) UNIQUE,
    address TEXT,
    date_of_birth DATE NOT NULL,
    membership_type ENUM('Student', 'Faculty', 'Public') NOT NULL,
    membership_status ENUM('Active', 'Expired', 'Suspended') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Library Cards Table (1:1 with Members)
CREATE TABLE library_cards (
    card_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL UNIQUE,
    card_number VARCHAR(20) UNIQUE NOT NULL,
    issue_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    barcode VARCHAR(50) UNIQUE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    CONSTRAINT chk_expiry_date CHECK (expiry_date > issue_date)
);

-- Loans Table (M:M between Books and Members)
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    due_date DATETIME NOT NULL,
    return_date DATETIME,
    status ENUM('Active', 'Returned', 'Overdue', 'Lost') DEFAULT 'Active',
    late_fee DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE RESTRICT,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE RESTRICT,
    CONSTRAINT chk_due_date CHECK (due_date > loan_date),
    CONSTRAINT chk_return_date CHECK (return_date IS NULL OR return_date >= loan_date)
);

-- Reservations Table (M:M between Books and Members)
CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    reservation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Fulfilled', 'Cancelled') DEFAULT 'Pending',
    expiry_date DATETIME,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    CONSTRAINT uc_active_reservation UNIQUE (book_id, member_id)
);

-- Fines Table (1:M with Members)
CREATE TABLE fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    loan_id INT,
    amount DECIMAL(10,2) NOT NULL,
    issue_date DATE NOT NULL,
    payment_date DATE,
    status ENUM('Pending', 'Paid', 'Waived') DEFAULT 'Pending',
    reason VARCHAR(255) NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE SET NULL
);

-- Sample Data
INSERT INTO authors (name, bio, birth_date, nationality) VALUES
('F. Scott Fitzgerald', 'American novelist and short story writer', '1896-09-24', 'American'),
('Harper Lee', 'American novelist famous for To Kill a Mockingbird', '1926-04-28', 'American'),
('J.K. Rowling', 'British author best known for Harry Potter series', '1965-07-31', 'British');

INSERT INTO publishers (name, address, contact_email, phone) VALUES
('Scribner', '123 Publishing Ave, New York, USA', 'info@scribner.com', '+1 212-555-1000'),
('HarperCollins', '456 Book St, London, UK', 'contact@harpercollins.co.uk', '+44 20-5555-2000');

INSERT INTO books (title, author_id, publisher_id, isbn, edition, publication_year, genre, total_copies, available_copies) VALUES
('The Great Gatsby', 1, 1, '9780743273565', '1st', 1925, 'Classic', 5, 3),
('To Kill a Mockingbird', 2, 2, '9780061120084', '2nd', 1960, 'Fiction', 3, 2),
('Harry Potter and the Philosopher''s Stone', 3, 2, '9780747532743', '1st', 1997, 'Fantasy', 10, 8);

INSERT INTO members (first_name, last_name, email, phone, address, date_of_birth, membership_type) VALUES
('Alice', 'Johnson', 'alice@example.com', '1234567890', 'Loresho', '2005-05-15', 'Faculty'),
('Amos', 'Maurice', 'amos@example.com', '9876543210', 'Runda', '2009-08-22', 'Student'),
('Carol', 'Mulwa', 'carol@example.com', '5551234567', 'Weslands', '1995-11-30', 'Public');

INSERT INTO library_cards (member_id, card_number, issue_date, expiry_date, barcode) VALUES
(1, 'LIB20230001', '2025-01-15', '2026-01-15', '123456789012'),
(2, 'LIB20230002', '2025-02-20', '2026-02-20', '234567890123'),
(3, 'LIB20230003', '2025-03-10', '2026-03-10', '345678901234');

INSERT INTO loans (book_id, member_id, loan_date, due_date, return_date, status) VALUES
(1, 1, '2023-06-01 10:00:00', '2023-06-15 10:00:00', NULL, 'Active'),
(2, 2, '2023-06-05 14:30:00', '2023-06-19 14:30:00', '2023-06-18 11:00:00', 'Returned'),
(3, 3, '2023-05-20 09:15:00', '2023-06-03 09:15:00', NULL, 'Overdue');
