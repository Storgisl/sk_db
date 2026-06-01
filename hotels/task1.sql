WITH CustomerStats AS (
    SELECT b.ID_customer,
           COUNT(b.ID_booking) AS total_bookings,
           COUNT(DISTINCT r.ID_hotel) AS unique_hotels,
           AVG(DATEDIFF(b.check_out_date, b.check_in_date)) AS avg_stay_days
    FROM Booking b
    JOIN Room r ON b.ID_room = r.ID_room
    GROUP BY b.ID_customer
    HAVING total_bookings > 2 AND unique_hotels > 1
)
SELECT c.name, c.email, c.phone, cs.total_bookings,
       (SELECT GROUP_CONCAT(DISTINCT h.name ORDER BY h.name SEPARATOR ', ')
        FROM Booking b
        JOIN Room r ON b.ID_room = r.ID_room
        JOIN Hotel h ON r.ID_hotel = h.ID_hotel
        WHERE b.ID_customer = c.ID_customer) AS hotels,
       cs.avg_stay_days
FROM Customer c
JOIN CustomerStats cs ON c.ID_customer = cs.ID_customer
ORDER BY cs.total_bookings DESC;
