from pathlib import Path
from sqlalchemy import text
from src.utils.db import get_engine

def execute_sql_file(engine, file_path: Path):
    """Read and Execute SQL File"""
    print(f"Executing: {file_path.name}")
    
    query = file_path.read_text()
        
    with engine.begin() as conn:
        for stmt in query.split(";"):
            if stmt.strip():
                conn.execute(text(stmt))

def run():
    print("Building data marts...")
    engine = get_engine()
    
    # IMPORTANT:
    # Dimensions must be loaded before facts.
    # Fact tables depend on dimension surrogate keys (foreign key references).
    sql_files = [
        "load_dim_date.sql",
        "load_dim_customer.sql",
        "load_dim_product.sql",
        "load_fact_sales.sql"
    ]

    # Resolve project root dynamically to allow execution
    # from different working directories
    project_root = Path(__file__).resolve().parents[2]
    marts_dir = project_root / "sql" / "marts"

    for file_name in sql_files:
        file_path = marts_dir / file_name
        try:
            execute_sql_file(engine, file_path)
            print(f"Success: {file_name}")
        except Exception as e:
            # Fail fast: stop the pipeline on any critical mart load error
            print(f"Error executing {file_name}: {e}")
            raise

    print("Data marts built successfully.")

if __name__ == "__main__":
    run()
