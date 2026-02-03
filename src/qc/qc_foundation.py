from pathlib import Path
import pandas as pd
from sqlalchemy import text
from src.utils.db import get_engine

def run():
    print("Starting Data Quality Checks (FOUNDATION)...")
    engine = get_engine()

    qc_file = (
        Path(__file__).resolve().parents[2]
        / "sql" / "qc" / "qc_foundation.sql"
    )

    if not qc_file.exists():
        raise FileNotFoundError(f"QC file not found: {qc_file}")

    with engine.begin() as conn:
        qc_df = pd.read_sql(text(qc_file.read_text()), conn)

    print("\n=== DATA QUALITY SUMMARY (FOUNDATION) ===")
    print(qc_df)

    output_path = "data/reports/foundation_quality_report.csv"
    qc_df.to_csv(output_path, index=False)

    # FAIL HARD: any non-zero count is a contract violation
    failures = qc_df[qc_df["count"] != 0]

    if not failures.empty:
        failure_msg = "\n".join(
            f"- {row.check_name}: {row.count}"
            for row in failures.itertuples(index=False)
        )
        raise RuntimeError(
            "FOUNDATION QUALITY GATE FAILED:\n" + failure_msg
        )

    print(f"Foundation quality gate PASSED. Report written to {output_path}")

if __name__ == "__main__":
    run()
