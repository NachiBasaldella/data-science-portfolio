
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



-- 1) Crear la tabla de calendario (estructura fija)
CREATE TABLE IF NOT EXISTS mart.calendar (
  date        date PRIMARY KEY,
  dow         int,
  dow_name    text,
  week        int,
  month       int,
  month_name  text,
  quarter     int,
  year        int
);

-- 2) Insertar (o rellenar) con el rango de fechas de mart.orders
WITH bounds AS (
  SELECT DATE(MIN(order_date)) AS dmin,
         DATE(MAX(order_date)) AS dmax
  FROM mart.orders
),
series AS (
  SELECT generate_series(dmin, dmax, interval '1 day')::date AS d
  FROM bounds
  WHERE dmin IS NOT NULL AND dmax IS NOT NULL      -- evita insertar si no hay órdenes
)
INSERT INTO mart.calendar (date, dow, dow_name, week, month, month_name, quarter, year)
SELECT d,
       EXTRACT(isodow FROM d)::int,
       TO_CHAR(d,'Dy'),
       EXTRACT(week FROM d)::int,
       EXTRACT(month FROM d)::int,
       TO_CHAR(d,'Mon'),
       EXTRACT(quarter FROM d)::int,
       EXTRACT(year FROM d)::int
FROM series
ON CONFLICT (date) DO NOTHING;


CREATE INDEX IF NOT EXISTS idx_calendar_date ON mart.calendar(date);

-- Asegura el esquema
CREATE SCHEMA IF NOT EXISTS mart;

-- Recrea la tabla
DROP TABLE IF EXISTS mart.inventory_snapshots;

CREATE TABLE mart.inventory_snapshots AS
WITH daily_sales AS (
    SELECT DATE(o.order_date) AS d,
           oi.product_id,
           SUM(oi.qty) AS units
    FROM mart.order_items oi
    JOIN mart.orders o USING (order_id)
    GROUP BY 1, 2
),
all_days AS (
    SELECT c.date AS d,
           p.product_id
    FROM mart.calendar c
    CROSS JOIN mart.products p
),
filled AS (
    SELECT a.d,
           a.product_id,
           COALESCE(ds.units, 0) AS units
    FROM all_days a
    LEFT JOIN daily_sales ds
      ON ds.d = a.d AND ds.product_id = a.product_id
),
cum AS (
    SELECT f.*,
           SUM(units) OVER (
               PARTITION BY product_id
               ORDER BY d
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ) AS cum_units
    FROM filled f
),
initial AS (
    SELECT product_id,
           200 + (abs(hashtext(product_id)) % 601)::int AS start_stock
    FROM mart.products
)
SELECT c.d AS snapshot_date,
       c.product_id,
       GREATEST(i.start_stock - c.cum_units, 0) AS on_hand
FROM cum c
JOIN initial i USING (product_id);




CREATE INDEX IF NOT EXISTS idx_inv_snap ON mart.inventory_snapshots(product_id, snapshot_date);

-- Ventas mensuales (excluye devoluciones)
SELECT DATE_TRUNC('month', o.order_date) AS month,
SUM(oi.qty * oi.unit_price) AS revenue,
SUM(oi.qty) AS units
FROM mart.order_items oi
JOIN mart.orders o USING(order_id)
WHERE o.is_return = false
GROUP BY 1
ORDER BY 1;


-- MoM por producto
WITH monthly AS (
SELECT DATE_TRUNC('month', o.order_date) AS month,
oi.product_id,
SUM(oi.qty * oi.unit_price) AS revenue
FROM mart.order_items oi
JOIN mart.orders o USING(order_id)
WHERE o.is_return = false
GROUP BY 1,2
)
SELECT month, product_id, revenue,
LAG(revenue) OVER (PARTITION BY product_id ORDER BY month) AS prev_revenue,
(revenue - LAG(revenue) OVER (PARTITION BY product_id ORDER BY month))
/ NULLIF(LAG(revenue) OVER (PARTITION BY product_id ORDER BY month),0) AS mom
FROM monthly
ORDER BY month, product_id;


-- Días con stockout
SELECT snapshot_date, product_id, on_hand
FROM mart.inventory_snapshots
WHERE on_hand = 0
ORDER BY snapshot_date, product_id;


-- Days of Inventory on Hand (DoH)
WITH daily_units AS (
SELECT DATE(o.order_date) AS d, oi.product_id, SUM(oi.qty) AS units
FROM mart.order_items oi
JOIN mart.orders o USING(order_id)
WHERE o.is_return = false
GROUP BY 1,2
), avg_daily AS (
SELECT product_id, AVG(units) AS avg_units
FROM daily_units
GROUP BY 1
)
SELECT i.snapshot_date, i.product_id, i.on_hand,
ROUND(i.on_hand / NULLIF(a.avg_units,0), 2) AS doh
FROM mart.inventory_snapshots i
LEFT JOIN avg_daily a USING(product_id)
ORDER BY i.snapshot_date, i.product_id;
