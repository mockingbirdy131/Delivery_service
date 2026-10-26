SELECT 
b.name,
COUNT(b.name) AS times_purchased
FROM
(
    SELECT 
    DISTINCT order_id,
    UNNEST(product_ids) AS product_id
    FROM orders
    WHERE
    order_id IN
    (
        SELECT order_id
        FROM courier_actions
        WHERE 
        action = 'deliver_order'
        AND DATE_TRUNC('month', time) = '2022-09-01 00:00:00'
    )
) AS a
LEFT JOIN
products AS b
USING(product_id)
GROUP BY b.name
ORDER BY times_purchased DESC
LIMIT 5
