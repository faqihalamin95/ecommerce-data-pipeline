from pathlib import Path
from sqlalchemy import text
from src.utils.db import get_engine

def execute_sql_file(engine, file_path: Path):
    print(f"Executing: {file_path.name}")
    query = file_path.read_text()

    with engine.begin() as conn:
        conn.execute(text(query))

def run():
    print("Building data staging...")
    engine = get_engine()
    
    # Resolve project root dynamically to allow execution
    # from different working directories
    project_root = Path(__file__).resolve().parents[2]
    staging_dir = project_root / "sql" / "load" / "staging" 
    sql_files = sorted(staging_dir.glob("*.sql"))

    if not sql_files:
        raise FileNotFoundError(f"No SQL files found in directory: {staging_dir}")

    for file_path in sql_files:
        try:
            execute_sql_file(engine, file_path)
            print(f"Success: {file_path.name}")

        except Exception as e:
            # Fail fast: stop the pipeline on any critical staging error
            print(f"Error executing {file_path.name}: {e}")
            raise

    print("Data staging built successfully.")

if __name__ == "__main__":
    run()
