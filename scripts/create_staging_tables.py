from utils import connect_to_db
import psycopg2
from psycopg2 import sql


# DB CONNECTION

conn, cursor = connect_to_db()


# CREATE TABLES IN STAGING SCHEMA (ORDERS)

cursor.execute("""
    CREATE TABLE IF NOT EXISTS staging.stg_orders (
        order_id TEXT PRIMARY KEY,
        customer_id TEXT,
        order_status TEXT,
        order_purchase_timestamp TIMESTAMP,
        order_approved_at TIMESTAMP,
        order_delivered_carrier_date TIMESTAMP,
        order_delivered_customer_date TIMESTAMP,
        order_estimated_delivery_date TIMESTAMP
    );
""")

## CREATE TABLES IN STAGING SCHEMA (ORDER_ITEMS)

cursor.execute("""
    CREATE TABLE IF NOT EXISTS staging.stg_order_items (
        order_id TEXT,
        order_item_id INTEGER,
        product_id TEXT,
        seller_id TEXT,
        shipping_limit_date TIMESTAMP,
        price NUMERIC(10,2),
        freight_value NUMERIC(10,2)
    );
""")

## CREATE TABLE IN STAGING SCHEMA (CUSTOMERS)

cursor.execute("""
CREATE TABLE IF NOT EXISTS staging.stg_customers (
    customer_id TEXT PRIMARY KEY,
    customer_unique_id TEXT,
    customer_zip_code_prefix TEXT,
    customer_city TEXT,
    customer_state TEXT
);
""")

## CREATE TABLE IN STAGING SCHEMA (PRODUCTS)

cursor.execute("""
      CREATE TABLE IF NOT EXISTS staging.stg_products (
        product_id TEXT PRIMARY KEY,
        product_category_name TEXT,
        product_name_length INTEGER,
        product_description_length INTEGER,
        product_photos_qty INTEGER,
        product_weight_g NUMERIC,
        product_length_cm NUMERIC,
        product_height_cm NUMERIC,
        product_width_cm NUMERIC
    );
""")


## COMMIT CHANGES AND CLOSE CONNECTION
conn.commit()
print("Staging tables created successfully!")

## CLOSE CONNECTION
cursor.close()
conn.close()


