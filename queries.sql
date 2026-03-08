
SELECT 
    f.flight_number,
    a1.city AS departure_city,
    a2.city AS arrival_city,
    f.departure_time,
    f.arrival_time,
    al.name AS airline
FROM flights f
JOIN airports a1 ON f.departure_airport_id = a1.airport_id
JOIN airports a2 ON f.arrival_airport_id = a2.airport_id
JOIN airlines al ON f.airline_id = al.airline_id
WHERE a1.city = 'New York' 
  AND a2.city = 'London'
  AND DATE(f.departure_time) = '2026-04-10'
  AND f.status = 'Scheduled';


SELECT 
    p.first_name,
    p.last_name,
    b.booking_id,
    f.flight_number,
    dep.iata_code AS from_airport,
    arr.iata_code AS to_airport,
    f.departure_time,
    f.arrival_time,
    t.seat_number,
    t.travel_class
FROM passengers p
JOIN bookings b ON p.passenger_id = b.passenger_id
JOIN flights f ON b.flight_id = f.flight_id
JOIN airports dep ON f.departure_airport_id = dep.airport_id
JOIN airports arr ON f.arrival_airport_id = arr.airport_id
JOIN tickets t ON b.booking_id = t.booking_id
WHERE p.passenger_id = 1;

SELECT 
    f.flight_number,
    SUM(b.total_amount) AS total_revenue
FROM flights f
JOIN bookings b ON f.flight_id = b.flight_id
WHERE f.flight_id = 1 AND b.status = 'Confirmed'
GROUP BY f.flight_number;

SELECT 
    f.flight_number,
    COUNT(t.ticket_id) AS booked_seats,
    (ac.economy_seats + ac.business_seats + ac.first_class_seats) AS total_capacity,
    (COUNT(t.ticket_id) * 100.0 / NULLIF((ac.economy_seats + ac.business_seats + ac.first_class_seats), 0)) AS occupancy_rate_percentage
FROM flights f
JOIN aircraft ac ON f.aircraft_id = ac.aircraft_id
LEFT JOIN bookings b ON f.flight_id = b.flight_id AND b.status = 'Confirmed'
LEFT JOIN tickets t ON b.booking_id = t.booking_id
WHERE f.flight_id = 1
GROUP BY f.flight_number, ac.economy_seats, ac.business_seats, ac.first_class_seats;

SELECT 
    f.flight_number,
    al.name AS airline,
    f.status,
    a1.city AS departure_city,
    a2.city AS arrival_city,
    f.departure_time
FROM flights f
JOIN airlines al ON f.airline_id = al.airline_id
JOIN airports a1 ON f.departure_airport_id = a1.airport_id
JOIN airports a2 ON f.arrival_airport_id = a2.airport_id
WHERE f.status IN ('Delayed', 'Canceled')
ORDER BY f.departure_time DESC;
