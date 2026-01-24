import pandas as pd
from datetime import datetime
import os
from src.utils.db import get_engine

def run():
    # Get database engine
    engine = get_engine()

    # Load CSV
    file_path = "data/raw/pakistan_largest_ecommerce_dataset.csv"
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"File not found: {file_path}")

    df = pd.read_csv(file_path, low_memory=False)
    # low_memory=False to prevent dtype warning

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

    # Load to PostgreSQL (idempotent pattern)
    with engine.begin() as conn:
        conn.execute("TRUNCATE TABLE raw.pakistan_ecommerce_raw;")
        df.to_sql(
            name="pakistan_ecommerce_raw",
            schema="raw",
            con=conn,
            if_exists="append",
            index=False,
            chunksize=10_000
        )

    print("Data ingestion completed successfully.")


if __name__ == "__main__":
    run()
