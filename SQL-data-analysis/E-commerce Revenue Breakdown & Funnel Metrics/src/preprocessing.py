
"""
preprocessing.py — Functions to clean and transform Olist data before analysis.
"""
import pandas as pd

def clean_orders(df: pd.DataFrame) -> pd.DataFrame:
    # Example: drop duplicates, standardize date formats
    df = df.drop_duplicates()
    if 'order_purchase_timestamp' in df.columns:
        df['order_purchase_timestamp'] = pd.to_datetime(df['order_purchase_timestamp'])
    return df

def clean_reviews(df: pd.DataFrame) -> pd.DataFrame:
    df = df.drop_duplicates()
    if 'review_creation_date' in df.columns:
        df['review_creation_date'] = pd.to_datetime(df['review_creation_date'])
    return df
