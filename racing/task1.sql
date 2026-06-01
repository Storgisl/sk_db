WITH CarAvg AS (
    SELECT c.name, c.class, AVG(r.position) AS avg_pos, COUNT(r.race) AS race_count
    FROM Cars c
    JOIN Results r ON c.name = r.car
    GROUP BY c.name, c.class
),
ClassMinAvg AS (
    SELECT class, MIN(avg_pos) AS min_avg
    FROM CarAvg
    GROUP BY class
)
SELECT ca.name AS car_name, ca.class AS car_class, ca.avg_pos AS average_position, ca.race_count
FROM CarAvg ca
JOIN ClassMinAvg cma ON ca.class = cma.class AND ca.avg_pos = cma.min_avg
ORDER BY ca.avg_pos;
