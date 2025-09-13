import argparse
from pathlib import Path
import pandas as pd
from sqlalchemy import create_engine


FILES = {
    "customers": "olist_customers_dataset.csv",
    "orders": "olist_orders_dataset.csv",
    "order_items": "olist_order_items_dataset.csv",
    "payments": "olist_order_payments_dataset.csv",
    "products": "olist_products_dataset.csv",
    "sellers": "olist_sellers_dataset.csv",
    "geolocation": "olist_geolocation_dataset.csv",
    "reviews": "olist_order_reviews_dataset.csv",
    "categories": "product_category_name_translation.csv",
}

DATE_COLS = {
    "orders": [
        "order_purchase_timestamp",
        "order_approved_at",
        "order_delivered_carrier_date",
        "order_delivered_customer_date",
        "order_estimated_delivery_date",
    ],
    "reviews": ["review_creation_date", "review_answer_timestamp"],
}

def parse_args():
    p = argparse.ArgumentParser(description="Load Olist CSVs into SQLite")
    p.add_argument("--raw-dir", type=str, default="data/raw", help="Folder with original CSVs")
    p.add_argument("--out-db", type=str, default="data/processed/olist.db", help="SQLite DB output path")
    p.add_argument("--if-exists", type=str, choices=["fail","replace","append"], default="replace")
    p.add_argument("--sample", type=int, default=0, help="Number of rows to load per file (0 = all)")
    p.add_argument("--fast", action="store_true", help="Use faster SQLite pragmas for local loading")
    return p.parse_args()

def read_csv_safely(path: Path, table: str, sample: int = 0) -> pd.DataFrame:
    kwargs = {}
    if table in DATE_COLS:
        kwargs["parse_dates"] = DATE_COLS[table]
    if sample and sample > 0:
        return pd.read_csv(path, nrows=sample, **kwargs)
    return pd.read_csv(path, **kwargs)

def main():
    args = parse_args()
    raw_dir = Path(args.raw_dir)
    db_path = Path(args.out_db)
    db_path.parent.mkdir(parents=True, exist_ok=True)

    missing = [f for f in FILES.values() if not (raw_dir / f).exists()]
    if missing:
        print("WARNING — Missing CSV files in", raw_dir)
        for m in missing:
            print("  -", m)

    engine = create_engine(f"sqlite:///{db_path}")
    with engine.begin() as conn:
        for table, fname in FILES.items():
            csv_path = raw_dir / fname
            if not csv_path.exists():
                print(f"SKIP {table}: file not found -> {csv_path}")
                continue
            print(f"Loading {table} from {csv_path} ...")
            df = read_csv_safely(csv_path, table, sample=args.sample)
            df.to_sql(table, conn, if_exists=args.if_exists, index=False)
            print(f"  -> {table}: {len(df):,} rows")

        print("Database created at:", db_path)

if __name__ == "__main__":
    main()
