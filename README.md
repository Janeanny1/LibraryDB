# LibraryDB

library-management-api/
│
├── README.md               # Project documentation
├── erd.png                 # ERD diagram (or link)
├── requirements.txt        # Python dependencies
│
├── database/               # SQL scripts
│   ├── setup.sql           # Database schema
│   └── sample_data.sql     # Optional test data
│
└── src/                    # Source code
    ├── main.py             # FastAPI app entry point
    ├── models.py           # Pydantic models
    ├── database.py         # MySQL connection
    ├── config.py           # Configuration (env vars)
    │
    └── routers/            # API endpoints
        ├── books.py        # Book-related routes
        ├── members.py      # Member-related routes
        └── loans.py        # Loan/borrowing routes
