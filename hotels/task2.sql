WITH CustomerSpending AS (
    SELECT b.ID_customer,
           COUNT(b.ID_booking) AS total_bookings,
           COUNT(DISTINCT r.ID_hotel) AS unique_hotels,
           SUM(r.price * DATEDIFF(b.check_out_date, b.check_in_date)) AS total_spent
    FROM Booking b
    JOIN Room r ON b.ID_room = r.ID_room
    GROUP BY b.ID_customer
)
SELECT cs.ID_customer, c.name, cs.total_bookings, cs.total_spent, cs.unique_hotels
FROM CustomerSpending cs
JOIN Customer c ON cs.ID_customer = c.ID_customer
WHERE cs.total_bookings > 2 AND cs.unique_hotels > 1 AND cs.total_spent > 500
ORDER BY cs.total_spent;
