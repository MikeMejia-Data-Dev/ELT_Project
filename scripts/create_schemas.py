import psycopg2
from utils import connect_to_db

##  DB CONECTION
conn, cursor = connect_to_db()

## CREATE SCHEMAS
schemas = ["raw", "staging", "marts"]

for schema in schemas:
    cursor.execute(f"CREATE SCHEMA IF NOT EXISTS {schema};")

## COMMIT CHANGES AND CLOSE CONNECTION
conn.commit()
print("Schemas created successfully!")

#CLOSE CONNECTION
cursor.close()
conn.close()