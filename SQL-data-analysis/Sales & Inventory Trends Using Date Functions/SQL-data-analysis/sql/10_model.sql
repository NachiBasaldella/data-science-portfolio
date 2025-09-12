
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS mart;


CREATE TABLE IF NOT EXISTS staging.ecommerce_raw (
InvoiceNo text,
StockCode text,
Description text,
Quantity integer,
InvoiceDate timestamp,
UnitPrice numeric(12,2),
CustomerID text,
Country text
);


SET datestyle = 'MDY';
COPY staging.ecommerce_raw (invoiceno, stockcode, description, quantity, invoicedate, unitprice, customerid, country)
FROM 'C:/Program Files/PostgreSQL/17/data/data/OnlineRetail.csv'
WITH (
  FORMAT csv,
  HEADER true,
  DELIMITER ';',  
  ENCODING 'UTF8'  
);

-- 1) Crear el esquema si no existe
CREATE SCHEMA IF NOT EXISTS mart;

-- 2) Crear la tabla si no existe
CREATE TABLE IF NOT EXISTS mart.products (
  product_id  text PRIMARY KEY,
  product_name text
);

-- Productos
INSERT INTO mart.products (product_id, product_name)
SELECT stockcode,
       MIN(NULLIF(btrim(description), '')) AS product_name
FROM staging.ecommerce_raw
WHERE stockcode IS NOT NULL
GROUP BY stockcode
ON CONFLICT (product_id) DO UPDATE
SET product_name = COALESCE(EXCLUDED.product_name, mart.products.product_name);


-- 1) Asegura el esquema
CREATE SCHEMA IF NOT EXISTS mart;

-- 2) Asegura la tabla
CREATE TABLE IF NOT EXISTS mart.customers (
  customer_id text PRIMARY KEY,
  country     text
);

-- Clientes
INSERT INTO mart.customers (customer_id, country)
SELECT CustomerID,
       MIN(Country) AS country        
FROM staging.ecommerce_raw
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ON CONFLICT (customer_id) DO UPDATE
SET country = COALESCE(EXCLUDED.country, mart.customers.country);


-- Órdenes
CREATE TABLE IF NOT EXISTS mart.orders (
order_id text PRIMARY KEY,
order_date timestamp NOT NULL,
customer_id text NULL,
country text,
is_return boolean DEFAULT false
);


-- Compatibilidad: usa FIRST_VALUE si tu PG < 16
INSERT INTO mart.orders (order_id, order_date, customer_id, country, is_return)
SELECT DISTINCT
r.InvoiceNo,
MIN(r.InvoiceDate) OVER (PARTITION BY r.InvoiceNo) AS order_date,
FIRST_VALUE(r.CustomerID) OVER (PARTITION BY r.InvoiceNo ORDER BY r.InvoiceDate) AS customer_id,
FIRST_VALUE(r.Country) OVER (PARTITION BY r.InvoiceNo ORDER BY r.InvoiceDate) AS country,
(LEFT(r.InvoiceNo,1) = 'C') AS is_return
FROM staging.ecommerce_raw r;


-- Ítems
CREATE TABLE IF NOT EXISTS mart.order_items (
order_id text REFERENCES mart.orders(order_id),
product_id text REFERENCES mart.products(product_id),
qty integer NOT NULL,
unit_price numeric(12,2) NOT NULL,
line_total numeric(14,2) GENERATED ALWAYS AS (qty * unit_price) STORED
);
INSERT INTO mart.order_items (order_id, product_id, qty, unit_price)
SELECT InvoiceNo, StockCode, Quantity, UnitPrice
FROM staging.ecommerce_raw
WHERE StockCode IS NOT NULL AND UnitPrice IS NOT NULL;


CREATE INDEX IF NOT EXISTS idx_items_order ON mart.order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_items_prod ON mart.order_items(product_id);
