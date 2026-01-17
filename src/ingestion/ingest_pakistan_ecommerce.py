import pandas as pd
from sqlalchemy import create_engine
from datetime import datetime
import os
from dotenv import load_dotenv

# Load env
load_dotenv("config/database.env")

DB_URL = (
    f"postgresql://{os.getenv('DB_USER')}:"
    f"{os.getenv('DB_PASSWORD')}@"
    f"{os.getenv('DB_HOST')}:"
    f"{os.getenv('DB_PORT')}/"
    f"{os.getenv('DB_NAME')}"
)

engine = create_engine(DB_URL)

# Load CSV
file_path = "data/raw/pakistan_largest_ecommerce_dataset.csv"
df = pd.read_csv(file_path, low_memory=False)

# Normalize column names
df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(" ", "_")
    .str.replace("-", "_")
)

# Basic type handling
df["created_at"] = pd.to_datetime(df["created_at"], errors="coerce")
df["working_date"] = pd.to_datetime(df["working_date"], errors="coerce")
df["customer_since"] = pd.to_datetime(df["customer_since"], errors="coerce")

# Audit columns
df["ingestion_time"] = datetime.now()
df["source_file"] = os.path.basename(file_path)

# Load to PostgreSQL
df.to_sql(
    name="pakistan_ecommerce_raw",
    schema="raw",
    con=engine,
    if_exists="append",
    index=False
)

# Log completion
print("Data ingestion completed successfully.")