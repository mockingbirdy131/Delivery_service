WITH 
users_count AS
(
    SELECT
    date,
    COUNT(user_id) AS new_users
    FROM
    (
        SELECT 
        DISTINCT user_id, 
        (MIN(time) OVER(PARTITION BY user_id))::DATE AS date
        FROM user_actions
    ) AS A
    GROUP BY date
),
couriers_count AS
(
    SELECT
    date,
    COUNT(courier_id) AS new_couriers
    FROM
    (
        SELECT 
        DISTINCT courier_id, 
        (MIN(time) OVER(PARTITION BY courier_id))::DATE AS date
        FROM courier_actions
    ) AS B
    GROUP BY date
)

SELECT 
date, new_users, new_couriers, total_users, total_couriers,
ROUND(100 * (new_users - LAG(new_users) OVER(ORDER BY date))::DECIMAL 
/ LAG(new_users) OVER(ORDER BY date), 2) AS new_users_change,
ROUND(100 * (new_couriers - LAG(new_couriers) OVER(ORDER BY date))::DECIMAL 
/ LAG(new_couriers) OVER(ORDER BY date), 2) AS new_couriers_change,
ROUND(100 * (total_users - LAG(total_users) OVER(ORDER BY date))::DECIMAL 
/ LAG(total_users) OVER(ORDER BY date), 2) AS total_users_growth,
ROUND(100 * (total_couriers - LAG(total_couriers) OVER(ORDER BY date))::DECIMAL 
/ LAG(total_couriers) OVER(ORDER BY date), 2) AS total_couriers_growth
FROM
(
    SELECT 
    users_count.date,
    new_users, new_couriers,
    SUM(new_users) OVER(ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)::INTEGER AS total_users,
    SUM(new_couriers) OVER(ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)::INTEGER AS total_couriers
    FROM
    couriers_count
    FULL JOIN 
    users_count
    USING(date)
) t
