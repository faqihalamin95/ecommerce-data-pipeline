from sqlalchemy import create_engine
import os
from dotenv import load_dotenv

# 1. Load file environment configuration
load_dotenv("config/database.env")

def get_db_url():
    """Build string database connection from environment variables"""
    user = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")
    host = os.getenv("DB_HOST")
    port = os.getenv("DB_PORT")
    dbname = os.getenv("DB_NAME")
    
    # Check wether variabel succesfully loaded (for debugging)
    if not user:
        raise ValueError("Environment variables not loaded. Look for path 'config/database.env'.")

    return f"postgresql://{user}:{password}@{host}:{port}/{dbname}"

def get_engine():
    # 2. Call the URL builder function
    db_url = get_db_url()
    return create_engine(db_url)
