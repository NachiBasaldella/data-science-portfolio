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
