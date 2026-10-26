SELECT
pair,
COUNT(pair) AS count_pair
FROM
(
    SELECT 
    DISTINCT A.order_id,
    ARRAY_SORT(ARRAY[A.name, B.name]) AS pair
    FROM
    (
        SELECT order_id, name 
        FROM
        (
            SELECT 
            order_id,
            UNNEST(product_ids) AS product_id
            FROM orders
            WHERE order_id NOT IN 
            (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
            ORDER BY product_id
        ) AS t1
        LEFT JOIN (SELECT name, product_id FROM products) AS t2
        USING(product_id)
    ) AS A
    LEFT JOIN
    (
        SELECT order_id, name 
        FROM
        (
            SELECT 
            order_id,
            UNNEST(product_ids) AS product_id
            FROM orders
            WHERE order_id NOT IN 
            (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
            ORDER BY product_id
        ) AS t3
        LEFT JOIN (SELECT name, product_id FROM products) AS t4
        USING(product_id)
    ) AS B
    USING(order_id)
    WHERE A.name != B.name
    ORDER BY order_id
) t
GROUP BY pair
ORDER BY count_pair DESC, pair
LIMIT 5
