import psycopg2
from pathlib import Path
from utils import connect_to_db

# ==========================================
# SQL FILES
# ==========================================

SQL_FILES = [

    "/mnt/c/Users/Mikes/Desktop/ELT-exercise/sql/MARTS/create_sales_by_customer.sql",

    "/mnt/c/Users/Mikes/Desktop/ELT-exercise/sql/MARTS/create_sales_by_product.sql"

]

# ==========================================
# MAIN PIPELINE
# ==========================================

def run_marts_pipeline():

    conn = None
    cursor = None

    try:

        # ======================================
        # CONNECT TO DATABASE
        # ======================================

        conn, cursor = connect_to_db()

        print("Connection successful.")
        print("=" * 50)

        # ======================================
        # EXECUTE SQL FILES
        # ======================================

        for sql_file in SQL_FILES:

            print(f"Executing: {sql_file}")

            with open(sql_file, "r", encoding="utf-8") as f:
                sql = f.read()

            cursor.execute(sql)

            print(f"Completed: {sql_file}")
            print("-" * 50)

        # ======================================
        # COMMIT AFTER ALL FILES SUCCEED
        # ======================================

        conn.commit()

        print("All MARTS created successfully.")

    except Exception as e:

        # ======================================
        # ROLLBACK ON FAILURE
        # ======================================

        if conn:
            conn.rollback()

        print(f"An error occurred: {e}")
        print("Rolled back changes due to error.")

    finally:

        # ======================================
        # CLEANUP
        # ======================================

        if cursor:
            cursor.close()

        if conn:
            conn.close()

        print("=" * 50)
        print("PostgreSQL connection closed.")

# ==========================================
# ENTRY POINT
# ==========================================

if __name__ == "__main__":
    run_marts_pipeline()