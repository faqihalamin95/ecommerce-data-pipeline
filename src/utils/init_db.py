from src.utils.db import get_engine
from sqlalchemy import text
from pathlib import Path

DDL_BASE_PATH = Path("sql/ddl")

DDL_FOLDERS = [
    "raw",
    "staging",
    "foundation",
    "marts"        
]

SCHEMAS = [
    "raw",
    "staging",
    "foundation",
    "marts"
]

def run_ddl_from_folder(conn, folder_path: Path):
    ddl_files = sorted(folder_path.glob("*.sql"))

    for ddl_file in ddl_files:
        print(f"Running DDL: {ddl_file}")
        with ddl_file.open("r") as f:
            query = f.read()
            conn.execute(text(query))


def init_tables():
    engine = get_engine()

    print("Initializing database schemas and tables...")

    with engine.begin() as conn:
        # Drop existing schemas (cascading)
        for schema in SCHEMAS:
            conn.execute(text(f"DROP SCHEMA IF EXISTS {schema} CASCADE;"))

        # Create schemas
        for schema in SCHEMAS:
            conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {schema};"))

        # Run DDLs by folder (ordered)
        for folder in DDL_FOLDERS:
            folder_path = DDL_BASE_PATH / folder

            if not folder_path.exists():
                raise FileNotFoundError(f"DDL folder not found: {folder_path}")

            run_ddl_from_folder(conn, folder_path)

    print("Database initialization completed successfully.")


if __name__ == "__main__":
    init_tables()
