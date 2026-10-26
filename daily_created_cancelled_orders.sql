SELECT 
DATE_TRUNC('day', time) AS day,
action,
COUNT(order_id) AS orders_count
FROM user_actions
GROUP BY day, action
ORDER BY day, action
