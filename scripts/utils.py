import psycopg2

##THIS IS THE CONECTION TO THE DATABASE

def connect_to_db():
    try:
        conn = psycopg2.connect(
            host="15.204.173.204",
            database="mike_db",
            user="coder-ra-c6",
            password="Riwi2026**",
            port="6432")
        
        cursor = conn.cursor()
        return conn, cursor
        print("Connection to the database was successful!")
    except Exception as e:
        print("An error occurred while connecting to the database:", e)
        return None, None