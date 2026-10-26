WITH 
users_count AS
(
    SELECT
        B.date,
        paying_users,
        SUM(new_users) OVER(ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)::INTEGER AS total_users
    FROM
    (
        SELECT
        min_date,
        COUNT(DISTINCT user_id) AS new_users
        FROM
        (
            SELECT 
            user_id, 
            (MIN(time) OVER(PARTITION BY user_id))::DATE AS min_date
            FROM user_actions
        ) t
        GROUP BY min_date
    ) AS A
    LEFT JOIN 
    (
        SELECT
        time::DATE AS date,
        COUNT(DISTINCT user_id) AS paying_users
        FROM user_actions
        WHERE order_id NOT IN 
        (SELECT  order_id FROM user_actions WHERE action = 'cancel_order')
        GROUP BY date
    ) AS B
    ON A.min_date = B.date
),
couriers_count AS
(
    SELECT
        B.date,
        SUM(new_couriers) OVER(ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)::INTEGER AS total_couriers,
        active_couriers
    FROM
    (
        SELECT
        min_date,
        COUNT(courier_id) AS new_couriers
        FROM
        (
            SELECT 
            DISTINCT courier_id, 
            (MIN(time) OVER(PARTITION BY courier_id))::DATE AS min_date
            FROM courier_actions
        ) AS A
        GROUP BY min_date
    ) AS A
    LEFT JOIN
    (
        SELECT
        time::DATE AS date,
        COUNT(DISTINCT courier_id) AS active_couriers
        FROM courier_actions
        WHERE order_id IN 
        (SELECT  order_id FROM courier_actions WHERE action = 'deliver_order')
        GROUP BY date
    ) AS B
    ON (A.min_date = B.date)
)

SELECT 
users_count.date,
paying_users,
active_couriers,
ROUND(100 * paying_users::DECIMAL / total_users , 2) AS paying_users_share,
ROUND(100 * active_couriers::DECIMAL / total_couriers , 2) AS active_couriers_share
FROM
couriers_count
LEFT JOIN 
users_count
USING(date)
