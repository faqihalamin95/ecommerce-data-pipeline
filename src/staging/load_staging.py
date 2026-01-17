import pandas as pd
from src.utils.db import get_engine

def run():
    print("Starting Staging Transformation...")
    engine = get_engine()
    
    # 1. Retrieve data from raw table
    df = pd.read_sql("SELECT * FROM raw.pakistan_ecommerce_raw", engine)
    
    # 2. Data Cleaning and Transformation
    # Erase duplicate rows
    df.dropna(how='all', inplace=True)
    
    # Convert data types
    df['created_at'] = pd.to_datetime(df['created_at'])
    df['price'] = pd.to_numeric(df['price'], errors='coerce').fillna(0)
    df['qty_ordered'] = pd.to_numeric(df['qty_ordered'], errors='coerce').fillna(0)

    # 3. Save to CSV or table staging (opsional)
    df.to_csv("data/staging/pakistan_ecommerce_cleaned.csv", index=False)
    
    print(f"Staging done. {len(df)} rows processed and cleaned.")

if __name__ == "__main__":
    run()