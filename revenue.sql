SELECT 
date,
daily_revenue,
revenue_growth_abs,
COALESCE(ROUND(100 * revenue_growth_abs / LAG(daily_revenue) OVER(ORDER BY date), 1), 
0) AS revenue_growth_percentage 
FROM
(   
    SELECT 
    date,
    daily_revenue,
    COALESCE(
    ROUND(daily_revenue - LAG(daily_revenue) OVER(ORDER BY date), 1), 
    0) AS revenue_growth_abs
    FROM
    (    
        SELECT
        creation_time::DATE AS date,
        ROUND(SUM(price) OVER(PARTITION BY creation_time::DATE), 1) AS daily_revenue
        FROM
        (
            SELECT 
            creation_time,
            UNNEST(product_ids) AS product_id
            FROM orders 
            WHERE order_id NOT IN 
            (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
        ) AS A
        LEFT JOIN
        products AS B
        USING(product_id)
    ) t
    GROUP BY date, daily_revenue
) tt
    
