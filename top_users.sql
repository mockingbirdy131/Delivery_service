SELECT
user_id,
COUNT(order_id) AS created_orders
FROM user_actions 
WHERE 
action = 'create_order'
AND  order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
GROUP BY user_id
ORDER BY created_orders DESC, user_id DESC
LIMIT 5
