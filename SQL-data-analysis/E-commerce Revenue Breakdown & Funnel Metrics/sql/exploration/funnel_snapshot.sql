SELECT 
  order_status,
  COUNT(DISTINCT order_id) AS num_orders
FROM orders
GROUP BY 1
ORDER BY num_orders DESC;
