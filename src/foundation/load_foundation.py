from pathlib import Path
from sqlalchemy import text
from src.utils.db import get_engine

def execute_sql_file(engine, file_path: Path):
    print(f"Executing: {file_path.name}")
    query = file_path.read_text()

    with engine.begin() as conn:
        conn.execute(text(query))

def run():
    print("Building data foundation...")
    engine = get_engine()
    
    # Resolve project root dynamically to allow execution
    # from different working directories
    project_root = Path(__file__).resolve().parents[2]
    foundation_dir = project_root / "sql" / "load" / "foundation"
    fact_dir = foundation_dir / "fact"
    dim_dir = foundation_dir / "dim"

    # NOTE: Dimension tables are expected to be built prior to fact tables

    if not dim_dir.exists():
        raise FileNotFoundError(f"No SQL files found in directory: {dim_dir}")
    dim_files = sorted(dim_dir.glob("*.sql"))
    for file_path in dim_files:
        try:
            execute_sql_file(engine, file_path)
            print(f"Success: {file_path.name}")
        except Exception as e:
            # Fail fast: stop the pipeline on any critical staging error
            print(f"Error executing {file_path.name}: {e}")
            raise

    if not fact_dir.exists():
        raise FileNotFoundError(f"No SQL files found in directory: {fact_dir}")
    fact_files = sorted(fact_dir.glob("*.sql"))
    for file_path in fact_files:
        try:
            execute_sql_file(engine, file_path)
            print(f"Success: {file_path.name}")
        except Exception as e:
            # Fail fast: stop the pipeline on any critical staging error
            print(f"Error executing {file_path.name}: {e}")
            raise

    print("Data foundation built successfully.")

if __name__ == "__main__":
    run()
