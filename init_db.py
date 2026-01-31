from src.utils.db import get_engine
from sqlalchemy import text

def init_tables():
    engine = get_engine()
    ddl_files = [
        "sql/ddl/01_raw_pakistan_ecommerce.sql",
        "sql/ddl/dim_date.sql",
        "sql/ddl/dim_customer.sql",
        "sql/ddl/dim_product.sql",
        "sql/ddl/fact_sales.sql"
    ]

    print("Initializing Database Tables...")
    with engine.connect() as conn:
        # CREATE SCHEMAS FIRST
        conn.execute(text("CREATE SCHEMA IF NOT EXISTS raw;"))
        conn.execute(text("CREATE SCHEMA IF NOT EXISTS mart;"))
        conn.commit()

        for file in ddl_files:
            with open(file, "r") as f:
                query = f.read()
                print(f"Running DDL: {file}")
                conn.execute(text(query))
                conn.commit()

    print("Tables created.")

if __name__ == "__main__":
    init_tables()
