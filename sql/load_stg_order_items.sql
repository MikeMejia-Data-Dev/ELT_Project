TRUNCATE TABLE staging.stg_order_items;

INSERT INTO staging.stg_order_items (
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
)

WITH cleaned_order_items AS (

    SELECT

        -- ==========================================
        -- STANDARDIZED IDENTIFIERS
        -- ==========================================

        TRIM(order_id) AS order_id,

        CASE
            WHEN order_item_id ~ '^\d+$'
            THEN order_item_id::INTEGER
            ELSE NULL
        END AS order_item_id,

        TRIM(product_id) AS product_id,

        TRIM(seller_id) AS seller_id,

        -- ==========================================
        -- SAFE TIMESTAMP CASTING
        -- ==========================================

        CASE
            WHEN shipping_limit_date ~
                 '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$'
            THEN shipping_limit_date::timestamp
            ELSE NULL
        END AS shipping_limit_date,

        -- ==========================================
        -- SAFE PRICE CASTING
        -- ==========================================

        CASE
            WHEN price ~ '^\d+(\.\d+)?$'
            THEN price::NUMERIC(10,2)
            ELSE NULL
        END AS price,

        -- ==========================================
        -- SAFE FREIGHT CASTING
        -- ==========================================

        CASE
            WHEN freight_value ~ '^\d+(\.\d+)?$'
            THEN freight_value::NUMERIC(10,2)
            ELSE NULL
        END AS freight_value

    FROM raw.order_items
)

SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value

FROM cleaned_order_items;