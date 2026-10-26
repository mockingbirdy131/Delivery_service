SELECT
CASE
    WHEN DATE_PART('dow', creation_time) IN (0, 6) THEN 'weekend'
    ELSE 'weekdays'
END AS week_part,
ROUND(AVG(ARRAY_LENGTH(product_ids, 1)), 2) AS avg_order_size
FROM orders
GROUP BY week_part
ORDER BY avg_order_size
