import pandas as pd
from src.utils.db import get_engine

# NOTE:
# This staging step is intended for data inspection and debugging only.
# Downstream mart models currently read directly from raw tables.

def run():
    print("Starting Data Quality Checks (Staging)...")
    engine = get_engine()

    df = pd.read_sql(
        "SELECT * FROM raw.pakistan_ecommerce_raw",
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
        "data/staging/data_quality_report.csv",
        index=False
    )

    # Critical QC check: created_at defines the time grain of the fact table
    # Currently logs a warning; can be promoted to a hard fail if required
    if qc["null_created_at"] > 0:
        print("WARNING: Found rows with NULL created_at")

    print("Staging QC completed.")

if __name__ == "__main__":
    run()
