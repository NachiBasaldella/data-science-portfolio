Sales & Inventory Trends (SQL — E-Commerce Data)

This repo builds a small data mart in Postgres from the Online Retail (UK) dataset and simulates inventory to analyze sales, stockouts, and Days of Hand (DoH).
https://www.kaggle.com/datasets/carrie1/ecommerce-data
Quick Start

Place the file at data/raw/OnlineRetail.csv.

Run in order:
sql/00_staging.sql → 10_model.sql → 20_calendar.sql → 30_inventory.sql → 40_queries.sql.

Export the results for visualization (optional).

Structure

staging.ecommerce_raw ← CSV load

mart.products, mart.customers, mart.orders, mart.order_items

mart.calendar, mart.inventory_snapshots

Notes

Invoices with prefix C = returns. They are flagged in orders.is_return.

Quantity can be negative (kept to calculate return KPIs).
