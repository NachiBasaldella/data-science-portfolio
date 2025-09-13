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
