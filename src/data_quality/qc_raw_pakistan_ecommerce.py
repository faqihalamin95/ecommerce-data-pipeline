import pandas as pd
from src.utils.db import get_engine

# This script performs data quality checks on staging tables.

def run():
    print("Starting Data Quality Checks (Staging)...")
    engine = get_engine()

    df = pd.read_sql(
        """
        SELECT
            created_at,
            sku,
            customer_id,
            price,
            qty_ordered
        FROM staging.stg_pakistan_ecommerce
        """,
        engine
    )

    total_rows = len(df)

    qc = {
        "total_rows": total_rows,
        "null_created_at": df["created_at"].isna().sum(),
        "null_sku": df["sku"].isna().sum(),
        "null_customer_id": df["customer_id"].isna().sum(),
        "negative_price": (df["price"] < 0).sum(),
        "zero_qty": (df["qty_ordered"] <= 0).sum(),
        "duplicate_rows": df.duplicated().sum(),
    }

    qc_df = pd.DataFrame(
        qc.items(),
        columns=["check_name", "count"]
    )

    print("\n=== DATA QUALITY SUMMARY ===")
    print(qc_df)

    qc_df.to_csv(
        "data/reports/data_quality_report.csv",
        index=False
    )

    # Currently logs a warning; can be promoted to a hard fail if required
    # created_at is chosen, because it's a critical field for time-based analyses
    if qc["null_created_at"] > 0:
        print("WARNING: Found rows with NULL created_at")

    print("Data staging QC completed.")

if __name__ == "__main__":
    run()
