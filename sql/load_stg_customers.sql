TRUNCATE TABLE staging.stg_customers;

INSERT INTO staging.stg_customers (
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
)

WITH cleaned_customers AS (

    SELECT

        TRIM(customer_id) AS customer_id,

        TRIM(customer_unique_id) AS customer_unique_id,

        CASE
            WHEN LOWER(TRIM(customer_zip_code_prefix))
                 IN ('', 'null', 'n/a', 'na')
            THEN NULL
            ELSE TRIM(customer_zip_code_prefix)
        END AS customer_zip_code_prefix,

        CASE
            WHEN LOWER(TRIM(customer_city))
                 IN ('', 'null', 'n/a', 'na')
            THEN NULL
            ELSE INITCAP(TRIM(customer_city))
        END AS customer_city,

        CASE
            WHEN LOWER(TRIM(customer_state))
                 IN ('', 'null', 'n/a', 'na')
            THEN NULL
            ELSE UPPER(TRIM(customer_state))
        END AS customer_state

    FROM raw.customers
),

deduplicated_customers AS (

    SELECT
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state,

        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY customer_unique_id
        ) AS rn

    FROM cleaned_customers
)

SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state

FROM deduplicated_customers

WHERE rn = 1;