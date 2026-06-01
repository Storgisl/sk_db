WITH ClassAvg AS (
    SELECT c.class, AVG(r.position) AS class_avg
    FROM Cars c
    JOIN Results r ON c.name = r.car
    GROUP BY c.class
),
MinClassAvg AS (
    SELECT MIN(class_avg) AS min_avg FROM ClassAvg
),
TargetClasses AS (
    SELECT class FROM ClassAvg WHERE class_avg = (SELECT min_avg FROM MinClassAvg)
),
CarDetails AS (
    SELECT c.name, c.class, AVG(r.position) AS avg_pos, COUNT(r.race) AS race_count, cl.country
    FROM Cars c
    JOIN Results r ON c.name = r.car
    JOIN Classes cl ON c.class = cl.class
    WHERE c.class IN (SELECT class FROM TargetClasses)
    GROUP BY c.name, c.class, cl.country
),
TotalRacesPerClass AS (
    SELECT class, COUNT(DISTINCT race) AS total_races
    FROM Cars c
    JOIN Results r ON c.name = r.car
    WHERE class IN (SELECT class FROM TargetClasses)
    GROUP BY class
)
SELECT cd.name AS car_name, cd.class AS car_class, cd.avg_pos AS average_position,
       cd.race_count, cd.country AS car_country, tr.total_races
FROM CarDetails cd
JOIN TotalRacesPerClass tr ON cd.class = tr.class
ORDER BY cd.class, cd.avg_pos;
