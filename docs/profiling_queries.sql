SELECT COUNT(*) FROM raw.orders;

SELECT COUNT(*) FROM raw.order_items;

SELECT COUNT(*) FROM raw.customers;

SELECT COUNT(*) FROM raw.products;

--this for inspect shema metada it returns column names in raw schema

SELECT
    table_schema,
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
ORDER BY table_name, ordinal_position;

-- Let's identify missing critical fields

SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (
        WHERE order_id IS NULL
           OR order_id = ''
    ) AS null_order_id,

    COUNT(*) FILTER (
        WHERE customer_id IS NULL
           OR customer_id = ''
    ) AS null_customer_id,

    COUNT(*) FILTER (
        WHERE order_purchase_timestamp IS NULL
           OR order_purchase_timestamp = ''
    ) AS null_purchase_timestamp

FROM raw.orders;


-- duplicated detection 

SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM raw.orders
GROUP BY order_id
HAVING COUNT(*) > 1;


SELECT *
FROM raw.orders
WHERE order_id IN (
    SELECT order_id
    FROM raw.orders
    GROUP BY order_id
    HAVING COUNT(*) > 1
)
ORDER BY order_id;

SELECT
    order_id,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT (
        customer_id,
        order_status,
        order_purchase_timestamp,
        order_approved_at,
        order_delivered_carrier_date,
        order_delivered_customer_date,
        order_estimated_delivery_date
    )) AS distinct_versions
FROM raw.orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT 
    SUM(cnt - 1) AS exact_duplicate_rows
FROM (
    SELECT
        customer_id,
        customer_unique_id,
        order_status,
        order_purchase_timestamp,
        order_approved_at,
        order_delivered_carrier_date,
        order_delivered_customer_date,
        order_estimated_delivery_date,
        COUNT(*) AS cnt
    FROM raw.orders
    GROUP BY
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp,
        order_approved_at,
        order_delivered_carrier_date,
        order_delivered_customer_date,
        order_estimated_delivery_date
    HAVING COUNT(*) > 1
) t;

SELECT  
    SUM(cnt - 1) AS exact_duplicate_rows  
FROM (  
    SELECT  
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state,
        COUNT(*) AS cnt  
    FROM raw.customers  
    GROUP BY  
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state
    HAVING COUNT(*) > 1  
) t;


SELECT  
    SUM(cnt - 1) AS exact_duplicate_rows  
FROM (  
    SELECT 
    	order_id,
        order_item_id,
        product_id,
        seller_id,
        shipping_limit_date,
        price,
        freight_value,
        COUNT(*) AS cnt  
    FROM raw.order_items  
    GROUP BY  
        order_id,
        order_item_id,
        product_id,
        seller_id,
        shipping_limit_date,
        price,
        freight_value
    HAVING COUNT(*) > 1  
) t;

SELECT  
    SUM(cnt - 1) AS exact_duplicate_rows  
FROM (  
    SELECT 
    	product_id,
        product_category_name,
        product_name_lenght,
        product_description_lenght,
        product_photos_qty,
        product_weight_g,
        product_length_cm,
        product_height_cm,
        product_width_cm,
        COUNT(*) AS cnt  
    FROM raw.products  
    GROUP BY  
        product_id,
        product_category_name,
        product_name_lenght,
        product_description_lenght,
        product_photos_qty,
        product_weight_g,
        product_length_cm,
        product_height_cm,
        product_width_cm
    HAVING COUNT(*) > 1  
) t;


-- malformed data detections

SELECT
    order_purchase_timestamp
FROM raw.orders
WHERE order_purchase_timestamp IS NOT NULL
  AND order_purchase_timestamp <> ''
  AND order_purchase_timestamp !~ '^\d{4}-\d{2}-\d{2}';


-- NUMERIC VALIDATION

SELECT
    price
FROM raw.order_items
WHERE price IS NOT NULL
  AND price <> ''
  AND price !~ '^\d+(\.\d+)?$';


-- referential integry analysis

SELECT
    oi.order_id
FROM raw.order_items oi
LEFT JOIN raw.orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- distinct customers

SELECT
    COUNT(DISTINCT customer_id)
FROM raw.customers;


--data lenght analysis

SELECT
    MIN(LENGTH(customer_id)) AS min_length,
    MAX(LENGTH(customer_id)) AS max_length
FROM raw.customers;
