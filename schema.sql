
CREATE TABLE airports (
    airport_id SERIAL PRIMARY KEY,
    iata_code VARCHAR(3) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL
);

CREATE TABLE airlines (
    airline_id SERIAL PRIMARY KEY,
    iata_code VARCHAR(2) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE aircraft (
    aircraft_id SERIAL PRIMARY KEY,
    airline_id INTEGER REFERENCES airlines(airline_id) ON DELETE CASCADE,
    model VARCHAR(100) NOT NULL,
    economy_seats INTEGER NOT NULL CHECK (economy_seats >= 0),
    business_seats INTEGER NOT NULL CHECK (business_seats >= 0),
    first_class_seats INTEGER NOT NULL CHECK (first_class_seats >= 0)
);

CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY,
    airline_id INTEGER REFERENCES airlines(airline_id) ON DELETE CASCADE,
    aircraft_id INTEGER REFERENCES aircraft(aircraft_id) ON DELETE SET NULL,
    flight_number VARCHAR(10) NOT NULL,
    departure_airport_id INTEGER REFERENCES airports(airport_id),
    arrival_airport_id INTEGER REFERENCES airports(airport_id),
    departure_time TIMESTAMP NOT NULL,
    arrival_time TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'Scheduled' CHECK (status IN ('Scheduled', 'Delayed', 'Departed', 'Arrived', 'Canceled')),
    base_price DECIMAL(10, 2) NOT NULL CHECK (base_price >= 0),
    CONSTRAINT flt_diff_airports CHECK (departure_airport_id != arrival_airport_id),
    CONSTRAINT flt_time_check CHECK (arrival_time > departure_time)
);

CREATE TABLE passengers (
    passenger_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    passport_number VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    passenger_id INTEGER REFERENCES passengers(passenger_id),
    flight_id INTEGER REFERENCES flights(flight_id),
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Confirmed' CHECK (status IN ('Pending', 'Confirmed', 'Canceled')),
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0)
);

CREATE TABLE tickets (
    ticket_id SERIAL PRIMARY KEY,
    booking_id INTEGER REFERENCES bookings(booking_id) ON DELETE CASCADE,
    seat_number VARCHAR(10),
    travel_class VARCHAR(20) CHECK (travel_class IN ('Economy', 'Business', 'First Class')),
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    UNIQUE(booking_id, seat_number) -- A seat on a booking should be unique
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    booking_id INTEGER REFERENCES bookings(booking_id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
    payment_method VARCHAR(50) CHECK (payment_method IN ('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer')),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Completed' CHECK (status IN ('Pending', 'Completed', 'Failed', 'Refunded'))
);

-- Indexes for performance
CREATE INDEX idx_flights_departure ON flights(departure_airport_id);
CREATE INDEX idx_flights_arrival ON flights(arrival_airport_id);
CREATE INDEX idx_flights_dept_time ON flights(departure_time);
CREATE INDEX idx_bookings_passenger ON bookings(passenger_id);
CREATE INDEX idx_bookings_flight ON bookings(flight_id);
