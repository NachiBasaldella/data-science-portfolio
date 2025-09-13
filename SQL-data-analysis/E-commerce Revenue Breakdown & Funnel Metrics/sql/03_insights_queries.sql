-- Total Revenue (Delivered only)
SELECT ROUND(SUM(p.payment_value), 2) AS revenue
FROM order_payments p
JOIN orders o USING(order_id)
WHERE o.order_status = 'delivered';

-- Payment Mix (Delivered)
WITH d AS (SELECT order_id FROM orders WHERE order_status = 'delivered')
SELECT 
  p.payment_type,
  COUNT(*) AS payments,
  ROUND(SUM(p.payment_value), 2) AS revenue,
  ROUND(SUM(p.payment_value) / COUNT(DISTINCT p.order_id), 2) AS AOV
FROM order_payments p
JOIN d ON d.order_id = p.order_id
GROUP BY 1
ORDER BY revenue DESC;

-- Repeat Purchase Rate
WITH delivered AS (
  SELECT o.customer_id, o.order_id
  FROM orders o
  WHERE o.order_status = 'delivered'
),
agg AS (
  SELECT customer_id, COUNT(*) AS cnt
  FROM delivered
  GROUP BY 1
)
SELECT 
  COUNT(DISTINCT CASE WHEN cnt >= 2 THEN customer_id END) * 1.0 /
  COUNT(DISTINCT customer_id) AS repeat_purchase_rate
FROM agg;

-- Delivery Performance + Reviews
WITH d AS (
  SELECT 
    o.order_id,
    julianday(o.order_delivered_customer_date) - julianday(o.order_purchase_timestamp) AS delivery_days
  FROM orders o
  WHERE o.order_status = 'delivered'
)
SELECT 
  ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
  ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM d
LEFT JOIN order_reviews r ON r.order_id = d.order_id;
