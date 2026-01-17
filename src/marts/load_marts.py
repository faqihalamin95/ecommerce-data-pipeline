import os
from sqlalchemy import text
from src.utils.db import get_engine

def execute_sql_file(engine, file_path):
    """Read and Execute SQL File"""
    print(f"Executing: {file_path}")
    
    with open(file_path, "r") as f:
        query = f.read()
        
    with engine.connect() as conn:
        # Using text() from sqlalchemy for raw query
        conn.execute(text(query))
        conn.commit()

def run():
    print("Building data marts...")
    engine = get_engine()
    
    # Order of execution is IMPORTANT: Dimension first, then Fact
    # Because Fact tables have Foreign Keys to Dimension tables
    sql_files = [
        "sql/marts/load_dim_date.sql",
        "sql/marts/load_dim_customer.sql",
        "sql/marts/load_dim_product.sql",
        "sql/marts/load_fact_sales.sql"
    ]

    base_dir = os.getcwd() # Get project root directory

    for file_name in sql_files:
        full_path = os.path.join(base_dir, file_name)
        try:
            execute_sql_file(engine, full_path)
            print(f"Success: {file_name}")
        except Exception as e:
            print(f"Error executing {file_name}: {e}")
            # Stop pipeline if there is a critical error
            raise e

    print("Data marts built successfully.")

if __name__ == "__main__":
    run()