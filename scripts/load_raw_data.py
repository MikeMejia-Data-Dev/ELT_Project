import os 
import psycopg2
from utils import connect_to_db

# DB CONNECTION

conn, cursor =  connect_to_db()

## FILE CONFIGURATION

DATA_PATH = "/mnt/c/Users/Mikes/Desktop/ELT-exercise/data"

files_to_tables = {
    "olist_orders_dataset.csv": "raw.orders",
    "olist_order_items_dataset.csv": "raw.order_items",
    "olist_customers_dataset.csv": "raw.customers",
    "olist_products_dataset.csv": "raw.products"
}

# LOAD FILES INTO POSTGRESQL

for file_name, table_name in files_to_tables.items():
    file_path = os.path.join(DATA_PATH, file_name)

    print(f"\n Loading file: {file_name}")

    ## VALIDATE FILE EXIST

    if not os.path.exists(file_path):
        print(f"File not found: {file_name}")
        continue

    ## BULK LOAD USING COPY

    try: 

        with open(file_path, "r", encoding="utf-8") as file:
            cursor.copy_expert(
                f"""
                COPY {table_name}
                FROM STDIN
                WITH (
                    FORMAT CSV,
                    HEADER TRUE,
                    DELIMITER ','
                )
                """,
                file
            )

        conn.commit()

        print(f"Successfully loaded into {table_name}")

    except Exception as error:

        conn.rollback()

        print(f"Error loading {file_name}")
        print(error)

## CLOSE CONNECTION

cursor.close()
conn.close()

print("\nRAW ingestion completed.")