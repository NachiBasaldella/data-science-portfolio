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
