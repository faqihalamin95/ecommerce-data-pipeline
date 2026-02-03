from pathlib import Path
import pandas as pd
from sqlalchemy import text
from src.utils.db import get_engine

def run():
    print("Starting Data Quality Checks (Staging)...")
    engine = get_engine()

    qc_file = (
        Path(__file__).resolve().parents[2]
        / "sql" / "qc" / "qc_staging.sql"
    )

    if not qc_file.exists():
        raise FileNotFoundError(f"QC file not found: {qc_file}")

    with engine.begin() as conn:
        qc_df = pd.read_sql(text(qc_file.read_text()), conn)

    print("\n=== DATA QUALITY SUMMARY (STAGING) ===")
    print(qc_df)

    output_path = "data/reports/staging_quality_report.csv"
    qc_df.to_csv(output_path, index=False)

    # soft warning only
    critical = qc_df.loc[
        qc_df["check_name"] == "null_created_at",
        "count"
    ].iloc[0]

    if critical > 0:
        print("WARNING: Found rows with NULL created_at")

    print(f"Staging QC completed. Report written to {output_path}")

if __name__ == "__main__":
    run()
