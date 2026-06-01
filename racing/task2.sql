WITH CarAvg AS (
    SELECT c.name, c.class, AVG(r.position) AS avg_pos, COUNT(r.race) AS race_count, cl.country
    FROM Cars c
    JOIN Results r ON c.name = r.car
    JOIN Classes cl ON c.class = cl.class
    GROUP BY c.name, c.class, cl.country
)
SELECT name AS car_name, class AS car_class, avg_pos AS average_position, 
       race_count, country AS car_country
FROM CarAvg
ORDER BY avg_pos, name
LIMIT 1;
