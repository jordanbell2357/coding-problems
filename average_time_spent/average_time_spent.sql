--subquery
SELECT
  DATE_FORMAT(visited_on, '%Y-%m-%d') AS visited_on,
  FORMAT(
    AVG(time_spent) OVER (
      ORDER BY
        visited_on ROWS BETWEEN 2 PRECEDING
        AND CURRENT ROW
    ),
    4
  ) AS avg_time_spent
FROM
  (
    SELECT
      t.visited_on,
      AVG(t.time_spent) AS time_spent
    FROM
      traffic t
      JOIN users u ON u.id = t.user_id
    WHERE
      u.user_type = 'user'
    GROUP BY
      t.visited_on
  ) AS subquery
ORDER BY
  visited_on;

--CTE
WITH user_traffic_summary AS (
  SELECT
    t.visited_on,
    AVG(t.time_spent) AS time_spent
  FROM
    traffic t
    JOIN users u ON u.id = t.user_id
  WHERE
    u.user_type = 'user'
  GROUP BY
    t.visited_on
)
SELECT
  DATE_FORMAT(visited_on, '%Y-%m-%d') AS visited_on,
  FORMAT(
    AVG(time_spent) OVER (
      ORDER BY
        visited_on ROWS BETWEEN 2 PRECEDING
        AND CURRENT ROW
    ),
    4
  ) AS avg_time_spent
FROM
  user_traffic_summary
ORDER BY
  visited_on;