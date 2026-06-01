WITH CarAvg AS (
    SELECT c.name, c.class, AVG(r.position) AS car_avg, COUNT(r.race) AS race_count, cl.country
    FROM Cars c
    JOIN Results r ON c.name = r.car
    JOIN Classes cl ON c.class = cl.class
    GROUP BY c.name, c.class, cl.country
),
ClassAvg AS (
    SELECT class, AVG(car_avg) AS class_avg, COUNT(*) AS cars_in_class
    FROM CarAvg
    GROUP BY class
    HAVING COUNT(*) >= 2
)
SELECT ca.name AS car_name, ca.class AS car_class, ca.car_avg AS average_position,
       ca.race_count, ca.country AS car_country
FROM CarAvg ca
JOIN ClassAvg cla ON ca.class = cla.class
WHERE ca.car_avg < cla.class_avg
ORDER BY ca.class, ca.car_avg;
