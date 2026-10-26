SELECT 
time_delivered::date AS date,
ROUND(AVG(delivery_time), 2) AS avg_delivery_time
FROM
(
    SELECT
    order_id,
    MIN(time) FILTER (WHERE action = 'accept_order') AS time_accepted,
    MIN(time) FILTER (WHERE action = 'deliver_order') AS time_delivered,
    ROUND(
        EXTRACT(EPOCH FROM MAX(time) - MIN(time)) / 60.0
    )::INTEGER AS delivery_time
    FROM courier_actions
    WHERE 
    order_id NOT IN (
        SELECT order_id FROM user_actions WHERE action =  'cancel_order'
    )
    GROUP BY order_id
) t
GROUP BY date
ORDER BY date
