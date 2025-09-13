-- Revenue by Category
SELECT 
  p.product_category_name AS category,
  ROUND(SUM(oi.price), 2) AS total_revenue,
  COUNT(DISTINCT oi.order_id) AS num_orders
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY 1
ORDER BY total_revenue DESC;

-- Revenue by State
SELECT 
  c.customer_state AS state,
  ROUND(SUM(oi.price), 2) AS total_revenue,
  COUNT(DISTINCT oi.order_id) AS num_orders
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY total_revenue DESC;

-- Payment Mix
SELECT 
  payment_type, 
  COUNT(*) AS payments,
  ROUND(SUM(payment_value), 2) AS revenue
FROM order_payments
GROUP BY 1
ORDER BY revenue DESC;

-- Average Order Value
SELECT ROUND(SUM(payment_value) * 1.0 / COUNT(DISTINCT order_id), 2) AS AOV
FROM order_payments;

-- Funnel Snapshot
WITH stages AS (
  SELECT 
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(CASE WHEN order_status='delivered' THEN 1 ELSE 0 END) AS delivered_orders,
    SUM(CASE WHEN order_status='canceled' THEN 1 ELSE 0 END) AS canceled_orders
  FROM orders
)
SELECT * FROM stages;
