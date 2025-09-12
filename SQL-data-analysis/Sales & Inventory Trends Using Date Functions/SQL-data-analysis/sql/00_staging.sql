
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
