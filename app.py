from flask import Flask, request, jsonify, send_from_directory
import sqlite3
import os

app = Flask(__name__, static_folder='public')

def get_db_connection():
    conn = sqlite3.connect('database.db')
    conn.row_factory = sqlite3.Row
    return conn

# Serve frontend files
@app.route('/')
def serve_index():
    return send_from_directory(app.static_folder, 'index.html')

@app.route('/<path:path>')
def serve_static(path):
    if os.path.exists(os.path.join(app.static_folder, path)):
        return send_from_directory(app.static_folder, path)
    return serve_index()

# API Endpoints

@app.route('/api/flights', methods=['GET'])
def get_flights():
    origin = request.args.get('origin', '').upper()
    destination = request.args.get('destination', '').upper()

    conn = get_db_connection()
    
    if origin and destination:
        flights = conn.execute(
            'SELECT * FROM flights WHERE origin = ? AND destination = ?',
            (origin, destination)
        ).fetchall()
        
        # If no strict matches, return all as fallback for demo
        if not flights:
            flights = conn.execute('SELECT * FROM flights').fetchall()
    else:
        flights = conn.execute('SELECT * FROM flights').fetchall()
        
    conn.close()
    
    return jsonify([dict(flight) for flight in flights])

@app.route('/api/book', methods=['POST'])
def book_flight():
    data = request.json
    user_id = data.get('user_id', 1) # Default to test user
    flight_id = data.get('flight_id')

    if not flight_id:
        return jsonify({'error': 'Flight ID is required'}), 400

    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        cursor.execute(
            'INSERT INTO bookings (user_id, flight_id) VALUES (?, ?)',
            (user_id, flight_id)
        )
        conn.commit()
        booking_id = cursor.lastrowid
        return jsonify({'message': 'Booking successful', 'booking_id': booking_id}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

@app.route('/api/bookings', methods=['GET'])
def get_user_bookings():
    user_id = request.args.get('user_id')
    if not user_id:
        return jsonify({'error': 'user_id is required'}), 400

    conn = get_db_connection()
    bookings = conn.execute('''
        SELECT b.id as booking_id, f.*
        FROM bookings b
        JOIN flights f ON b.flight_id = f.id
        WHERE b.user_id = ?
        ORDER BY b.id DESC
    ''', (user_id,)).fetchall()
    conn.close()

    return jsonify([dict(b) for b in bookings])

@app.route('/api/auth/login', methods=['POST'])
def login():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    conn = get_db_connection()
    user = conn.execute(
        'SELECT id, name, email FROM users WHERE email = ? AND password = ?',
        (email, password)
    ).fetchone()
    conn.close()

    if user:
        return jsonify(dict(user))
    else:
        return jsonify({'error': 'Invalid credentials'}), 401

@app.route('/api/auth/signup', methods=['POST'])
def signup():
    data = request.json
    name = data.get('name')
    email = data.get('email')
    password = data.get('password')

    if not name or not email or not password:
        return jsonify({'error': 'Name, email, and password are required'}), 400

    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        cursor.execute(
            'INSERT INTO users (name, email, password) VALUES (?, ?, ?)',
            (name, email, password)
        )
        conn.commit()
        user_id = cursor.lastrowid
        return jsonify({'id': user_id, 'name': name, 'email': email}), 201
    except sqlite3.IntegrityError:
        return jsonify({'error': 'Email already exists'}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

if __name__ == '__main__':
    app.run(debug=True, port=3000)
