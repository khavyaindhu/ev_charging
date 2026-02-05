from flask import Flask, request, jsonify
from flask_cors import CORS
import psycopg2
from psycopg2.extras import RealDictCursor
from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()

app = Flask(__name__)

# Enable CORS
CORS(app)

# Database configuration
DB_USER = os.getenv("DB_USER")
DB_HOST = os.getenv("DB_HOST")
DB_NAME = os.getenv("DB_NAME")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_PORT = os.getenv("DB_PORT")

# Connect to the database
def get_db_connection():
    conn = psycopg2.connect(
        user=DB_USER,
        password=DB_PASSWORD,
        host=DB_HOST,
        port=DB_PORT,
        database=DB_NAME
    )
    return conn

# Route to add a user
@app.route("/register", methods=["POST"])
def register_user():
    data = request.get_json()
    name = data.get("name")
    email = data.get("email")
    password = data.get("password")
    role = data.get("role")

    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(
            "INSERT INTO users (name, email, password, role) VALUES (%s, %s, %s, %s)",
            (name, email, password, role),
        )
        conn.commit()
        return jsonify({"message": "User registered successfully"}), 201
    except psycopg2.IntegrityError:
        conn.rollback()
        return jsonify({"message": "Email already exists"}), 400
    finally:
        cursor.close()
        conn.close()

# Route to get all users
@app.route("/users", methods=["GET"])
def get_users():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute("SELECT * FROM users")
    users = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(users), 200


# Route for user login
@app.route("/login", methods=["POST"])
def login_user():
    data = request.get_json()
    email = data.get("email")
    password = data.get("password")

    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute("SELECT * FROM users WHERE email = %s AND password = %s", (email, password))
    user = cursor.fetchone()
    cursor.close()
    conn.close()

    if user:
        return jsonify({
            "message": "Login successful",
            "user": {
                "id": user["id"],
                "name": user["name"],
                "email": user["email"],
                "role": user["role"]
            }
        }), 200
    else:
        return jsonify({"message": "Invalid email or password"}), 401




# Endpoint to insert a new charging station
@app.route("/charging-stations", methods=["POST"])
def add_charging_station():
    data = request.get_json()
    station_name = data.get("station_name")
    latitude = data.get("latitude")
    longitude = data.get("longitude")

    if not station_name or not latitude or not longitude:
        return jsonify({"message": "All fields are required"}), 400

    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(
            "INSERT INTO charging_stations (station_name, latitude, longitude) VALUES (%s, %s, %s)",
            (station_name, latitude, longitude),
        )
        conn.commit()
        return jsonify({"message": "Charging station added successfully"}), 201
    except Exception as e:
        conn.rollback()
        return jsonify({"message": f"Error adding charging station: {str(e)}"}), 500
    finally:
        cursor.close()
        conn.close()

# Endpoint to fetch all charging stations
@app.route("/charging-stations", methods=["GET"])
def get_charging_stations():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    print("== Get charging-stations API hit ==") 
    
    try:
        cursor.execute("SELECT * FROM charging_stations")
        stations = cursor.fetchall()
        return jsonify(stations), 200
    except Exception as e:
        return jsonify({"message": f"Error fetching charging stations: {str(e)}"}), 500
    finally:
        cursor.close()
        conn.close()

if __name__ == "__main__":
    app.run(debug=True, port=int(os.getenv("PORT", 5000)))
