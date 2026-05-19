from utils import connect_to_db
import psycopg2
from pathlib import Path




## STAGING FILES
SQL_FILE = [
    "/mnt/c/Users/Mikes/Desktop/ELT-exercise/sql/load_stg_customers.sql",
    "/mnt/c/Users/Mikes/Desktop/ELT-exercise/sql/load_stg_order_items.sql",
    "/mnt/c/Users/Mikes/Desktop/ELT-exercise/sql/load_stg_orders.sql",
    "/mnt/c/Users/Mikes/Desktop/ELT-exercise/sql/load_stg_products.sql"
]

##  SQL EXECUTION FUNCTION

def execute_sql_file(cursor, file_path):

    print(f"Executing: {file_path}")

    with open(file_path, "r", encoding="utf-8") as file:
        sql_script = file.read()

    cursor.execute(sql_script)

    print(f"Completed: {file_path}")
    print("-" * 50)


## MAIN PIPELINE EXECUTION

def run_stating_pipeline():

    connection = None

    try:
        ## DB CONNECTION

        print("Connecting to the database...")
        conn, cursor = connect_to_db()
        print("Connected to the database successfully.")

        print("=" * 50)

        ## EXECUTING SQL FILES

        for sql_file in SQL_FILE:
            execute_sql_file(cursor, sql_file)

        ## COMMIT CHANGES

        conn.commit()
        print("=" * 50)
        print("All changes committed successfully.")

    except Exception as e:

        ## ROLLBACK FAILURE
        print(f"An error occurred: {e}")
        if connection:
            conn.rollback()
            print("Rolled back any changes due to the error.")
    
    finally:

        ## CLEANUP
        if connection:
            cursor.close()
            conn.close()
            print("=" * 50)
            print("Database connection closed.")

# ENTRY POINT

if __name__ == "__main__":
    run_stating_pipeline()