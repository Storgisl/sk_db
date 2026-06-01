WITH CarAvg AS (
    SELECT c.name, c.class, AVG(r.position) AS avg_pos, COUNT(r.race) AS race_count, cl.country
    FROM Cars c
    JOIN Results r ON c.name = r.car
    JOIN Classes cl ON c.class = cl.class
    GROUP BY c.name, c.class, cl.country
),
ClassLowCount AS (
    SELECT class, COUNT(*) AS low_position_count
    FROM CarAvg
    WHERE avg_pos > 3.0
    GROUP BY class
),
MaxLowCount AS (
    SELECT MAX(low_position_count) AS max_low FROM ClassLowCount
),
TargetClasses AS (
    SELECT class FROM ClassLowCount WHERE low_position_count = (SELECT max_low FROM MaxLowCount)
)
SELECT ca.name AS car_name, ca.class AS car_class, ca.avg_pos AS average_position,
       ca.race_count, ca.country AS car_country,
       (SELECT COUNT(DISTINCT race) FROM Results r WHERE r.car IN 
            (SELECT name FROM Cars WHERE class = ca.class)) AS total_races,
       clc.low_position_count
FROM CarAvg ca
JOIN ClassLowCount clc ON ca.class = clc.class
WHERE ca.class IN (SELECT class FROM TargetClasses)
ORDER BY clc.low_position_count DESC, ca.class, ca.avg_pos;
