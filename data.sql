
-- 1. Airports
INSERT INTO airports (iata_code, name, city, country) VALUES
('JFK', 'John F. Kennedy International Airport', 'New York', 'USA'),
('LHR', 'Heathrow Airport', 'London', 'UK'),
('CDG', 'Charles de Gaulle Airport', 'Paris', 'France'),
('DXB', 'Dubai International Airport', 'Dubai', 'UAE'),
('SIN', 'Singapore Changi Airport', 'Singapore', 'Singapore'),
('HND', 'Tokyo Haneda Airport', 'Tokyo', 'Japan');

-- 2. Airlines
INSERT INTO airlines (iata_code, name) VALUES
('AA', 'American Airlines'),
('BA', 'British Airways'),
('AF', 'Air France'),
('EK', 'Emirates'),
('SQ', 'Singapore Airlines'),
('JL', 'Japan Airlines');

-- 3. Aircraft
INSERT INTO aircraft (airline_id, model, economy_seats, business_seats, first_class_seats) VALUES
(1, 'Boeing 777', 200, 40, 10),
(2, 'Airbus A380', 300, 60, 14),
(3, 'Airbus A350', 250, 48, 0),
(4, 'Airbus A380', 350, 76, 14),
(5, 'Boeing 787', 240, 36, 0),
(6, 'Boeing 777', 220, 42, 8);

-- 4. Flights
INSERT INTO flights (airline_id, aircraft_id, flight_number, departure_airport_id, arrival_airport_id, departure_time, arrival_time, status, base_price) VALUES
(1, 1, 'AA100', 1, 2, '2026-04-10 18:00:00', '2026-04-11 06:00:00', 'Scheduled', 450.00),
(2, 2, 'BA200', 2, 4, '2026-04-11 09:00:00', '2026-04-11 19:30:00', 'Scheduled', 600.00),
(3, 3, 'AF300', 3, 1, '2026-04-12 10:00:00', '2026-04-12 22:00:00', 'Scheduled', 550.00),
(4, 4, 'EK400', 4, 5, '2026-04-13 14:00:00', '2026-04-14 01:00:00', 'Scheduled', 700.00),
(5, 5, 'SQ500', 5, 6, '2026-04-14 08:00:00', '2026-04-14 15:30:00', 'Delayed', 300.00),
(6, 6, 'JL600', 6, 1, '2026-04-15 11:00:00', '2026-04-15 23:30:00', 'Scheduled', 800.00);

-- 5. Passengers
INSERT INTO passengers (first_name, last_name, email, phone, passport_number) VALUES
('John', 'Doe', 'john.doe@example.com', '+1234567890', 'A12345678'),
('Jane', 'Smith', 'jane.smith@example.com', '+0987654321', 'B87654321'),
('Alice', 'Johnson', 'alice.j@example.com', '+1122334455', 'C11223344'),
('Bob', 'Brown', 'bob.b@example.com', '+5544332211', 'D44332211'),
('Charlie', 'Davis', 'charlie.d@example.com', '+6677889900', 'E99887766');

-- 6. Bookings
INSERT INTO bookings (passenger_id, flight_id, booking_date, status, total_amount) VALUES
(1, 1, '2026-03-01 10:00:00', 'Confirmed', 500.00),
(2, 2, '2026-03-02 11:30:00', 'Confirmed', 1500.00),
(3, 3, '2026-03-03 09:15:00', 'Confirmed', 550.00),
(4, 4, '2026-03-04 14:20:00', 'Confirmed', 700.00),
(5, 5, '2026-03-05 16:45:00', 'Confirmed', 300.00);

-- 7. Tickets
INSERT INTO tickets (booking_id, seat_number, travel_class, price) VALUES
(1, '12A', 'Economy', 500.00),
(2, '2A', 'First Class', 1500.00),
(3, '15C', 'Economy', 550.00),
(4, '34B', 'Economy', 700.00),
(5, '22D', 'Economy', 300.00);

-- 8. Payments
INSERT INTO payments (booking_id, amount, payment_method, payment_date, status) VALUES
(1, 500.00, 'Credit Card', '2026-03-01 10:05:00', 'Completed'),
(2, 1500.00, 'PayPal', '2026-03-02 11:35:00', 'Completed'),
(3, 550.00, 'Debit Card', '2026-03-03 09:20:00', 'Completed'),
(4, 700.00, 'Credit Card', '2026-03-04 14:25:00', 'Completed'),
(5, 300.00, 'Bank Transfer', '2026-03-05 16:50:00', 'Completed');
