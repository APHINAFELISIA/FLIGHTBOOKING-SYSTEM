import sqlite3

def init_db():
    conn = sqlite3.connect('database.db')
    cursor = conn.cursor()

    # Create Users Table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
        )
    ''')

    # Create Flights Table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS flights (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            airline TEXT NOT NULL,
            airline_name TEXT NOT NULL,
            price REAL NOT NULL,
            departure_time TEXT NOT NULL,
            arrival_time TEXT NOT NULL,
            duration TEXT NOT NULL,
            origin TEXT NOT NULL,
            destination TEXT NOT NULL
        )
    ''')

    # Create Bookings Table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS bookings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            flight_id INTEGER NOT NULL,
            booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users(id),
            FOREIGN KEY (flight_id) REFERENCES flights(id)
        )
    ''')

    # Insert sample seed data
    
    # 1. Sample User
    try:
        cursor.execute("INSERT INTO users (name, email, password) VALUES ('Test User', 'test@test.com', 'password')")
    except sqlite3.IntegrityError:
        pass # User already exists

    # 2. Clear out flights to reseed
    cursor.execute('DELETE FROM flights')
    
    # 3. Sample Flights
    sample_flights = [
        ("AA", "American Airlines", 450.00, "18:00", "06:00", "7h 00m", "JFK", "LHR"),
        ("BA", "British Airways", 600.00, "09:00", "19:30", "6h 30m", "JFK", "LHR"),
        ("AF", "Air France", 550.00, "10:00", "22:00", "7h 30m", "JFK", "LHR"),
        ("DL", "Delta Airlines", 350.00, "08:00", "11:00", "3h 00m", "JFK", "MIA"),
        ("UA", "United Airlines", 410.00, "13:00", "16:15", "3h 15m", "JFK", "MIA"),
        ("EK", "Emirates", 1200.00, "22:00", "19:00", "13h 00m", "JFK", "DXB")
    ]
    cursor.executemany('''
        INSERT INTO flights (airline, airline_name, price, departure_time, arrival_time, duration, origin, destination)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''', sample_flights)

    conn.commit()
    conn.close()
    print("Database initialized and seeded successfully.")

if __name__ == '__main__':
    init_db()
