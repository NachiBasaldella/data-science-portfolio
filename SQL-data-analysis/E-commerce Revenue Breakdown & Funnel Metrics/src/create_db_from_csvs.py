import argparse
from pathlib import Path
import pandas as pd
from sqlalchemy import create_engine, text

# --- Ajusta aquí si tienes columnas de fecha conocidas ---
DATE_COLS = {
    "orders": [
        "order_purchase_timestamp",
        "order_approved_at",
        "order_delivered_carrier_date",
        "order_delivered_customer_date",
        "order_estimated_delivery_date",
    ],
}

def table_name_from_csv(csv_path: Path) -> str:
    """
    Convierte 'olist_orders_dataset.csv' -> 'orders', etc.
    Quita prefijos 'olist_' y sufijos '_dataset'.
    """
    stem = csv_path.stem  # nombre sin extensión
    name = stem.lower()
    for prefix in ("olist_",):
        if name.startswith(prefix):
            name = name[len(prefix):]
    for suffix in ("_dataset",):
        if name.endswith(suffix):
            name = name[: -len(suffix)]
    # nombres válidos en SQLite (sin espacios, etc.)
    name = name.replace(" ", "_")
    return name

def load_folder_to_sqlite(csv_dir: Path, db_path: Path):
    csv_dir = Path(csv_dir)
    db_path = Path(db_path)

    # Crea carpeta si no existe
    db_path.parent.mkdir(parents=True, exist_ok=True)

    # Crea/abre la base
    engine = create_engine(f"sqlite:///{db_path}")

    # Activa foreign_keys en cada conexión
    with engine.connect() as conn:
        conn.execute(text("PRAGMA foreign_keys = ON;"))

    csv_files = sorted(csv_dir.glob("*.csv"))
    if not csv_files:
        raise FileNotFoundError(f"No encontré CSVs en: {csv_dir}")

    for csv in csv_files:
        table = table_name_from_csv(csv)
        parse_dates = DATE_COLS.get(table, [])

        print(f"→ Cargando {csv.name} como tabla '{table}'...")
        # Si tus CSV son grandes, usa chunksize para no quedarte sin RAM
        first = True
        for chunk in pd.read_csv(
            csv,
            parse_dates=parse_dates,
            chunksize=100_000,
            low_memory=False,
        ):
            chunk.to_sql(
                table,
                engine,
                if_exists="replace" if first else "append",
                index=False,
            )
            first = False

        # (Opcional) crea índices útiles
        with engine.begin() as conn:
            if table == "orders":
                conn.execute(text("CREATE INDEX IF NOT EXISTS idx_orders_customer ON orders(customer_id);"))
            if table == "order_items":
                conn.execute(text("CREATE INDEX IF NOT EXISTS idx_items_order ON order_items(order_id);"))
            if table == "reviews":
                conn.execute(text("CREATE INDEX IF NOT EXISTS idx_reviews_order ON reviews(order_id);"))
        print(f"   ✓ Tabla '{table}' cargada.")

    print(f"\nListo. Base creada en: {db_path}")

    # Mostrar tablas creadas
    with engine.connect() as conn:
        tables = conn.exec_driver_sql(
            "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;"
        ).fetchall()
    print("Tablas en la base:", [t[0] for t in tables])

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Crear SQLite .db a partir de CSVs")
    p.add_argument("--csv_dir", required=True, help="Carpeta que contiene los .csv")
    p.add_argument("--db_path", required=True, help="Ruta del archivo .db a crear")
    args = p.parse_args()

    load_folder_to_sqlite(Path(args.csv_dir), Path(args.db_path))

import sqlite3

conn = sqlite3.connect(r"C:\Users\nazar\OneDrive\Documentos\data\olist.db")
cursor = conn.cursor()

# Listar tablas
cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
print(cursor.fetchall())

# Ver primeras filas de "orders"
cursor.execute("SELECT * FROM orders LIMIT 5;")
for row in cursor.fetchall():
    print(row)

import pandas as pd

df = pd.read_sql("SELECT * FROM orders LIMIT 10;", conn)
print(df.head())
