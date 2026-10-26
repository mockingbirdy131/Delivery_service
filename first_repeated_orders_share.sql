SELECT
date,
order_type,
COUNT(order_id) AS orders_count,
round(COUNT(order_id)::decimal / 
SUM(COUNT(order_id)) OVER(PARTITION BY date), 2) as orders_share
FROM
(
    SELECT 
    order_id,
    time::DATE AS date,
    CASE
        WHEN time = (MIN(time) OVER(PARTITION BY user_id)) THEN 'Первый'
        ELSE 'Повторный'
    END AS order_type
    FROM user_actions
    WHERE order_id NOT IN 
    (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
) t
GROUP BY date, order_type
ORDER BY date, order_type
