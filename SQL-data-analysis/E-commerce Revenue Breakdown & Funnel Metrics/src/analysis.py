
"""
analysis.py — Helper functions to run SQL queries and compute metrics.
"""
import pandas as pd
import sqlite3

def run_query(db_path: str, query: str) -> pd.DataFrame:
    conn = sqlite3.connect(db_path)
    df = pd.read_sql_query(query, conn)
    conn.close()
    return df

def revenue_by_category(db_path: str) -> pd.DataFrame:
    q = """
    SELECT 
        p.product_category_name AS category,
        ROUND(SUM(oi.price), 2) AS total_revenue,
        COUNT(DISTINCT oi.order_id) AS num_orders
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY 1
    ORDER BY total_revenue DESC;
    """
    return run_query(db_path, q)
