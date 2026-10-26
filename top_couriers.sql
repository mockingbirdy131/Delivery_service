SELECT
courier_id, orders_count, courier_rank 
FROM
(
    SELECT
    courier_id, orders_count,
    ROW_NUMBER() OVER(ORDER BY orders_count DESC, courier_id) AS courier_rank
    FROM
    (
        SELECT 
        courier_id, 
        COUNT(order_id) AS orders_count
        FROM courier_actions
        WHERE action = 'deliver_order'
        GROUP BY courier_id
    ) t
) tt
LIMIT 5
