TRUNCATE TABLE staging.stg_products;

INSERT INTO staging.stg_products (
    product_id,
    product_category_name,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)

WITH cleaned_products AS (

    SELECT

        -- ==========================================
        -- STANDARDIZED PRODUCT ID
        -- ==========================================

        TRIM(product_id) AS product_id,

        -- ==========================================
        -- CATEGORY STANDARDIZATION
        -- ==========================================

        CASE
            WHEN LOWER(TRIM(product_category_name))
                 IN ('', 'null', 'n/a', 'na')
            THEN NULL
            ELSE LOWER(TRIM(product_category_name))
        END AS product_category_name,

        -- ==========================================
        -- SAFE INTEGER CASTING
        -- ==========================================

        CASE
            WHEN product_name_lenght ~ '^\d+$'
            THEN product_name_lenght::INTEGER
            ELSE NULL
        END AS product_name_length,

        CASE
            WHEN product_description_lenght ~ '^\d+$'
            THEN product_description_lenght::INTEGER
            ELSE NULL
        END AS product_description_length,

        CASE
            WHEN product_photos_qty ~ '^\d+$'
            THEN product_photos_qty::INTEGER
            ELSE NULL
        END AS product_photos_qty,

        -- ==========================================
        -- SAFE NUMERIC CASTING
        -- ==========================================

        CASE
            WHEN product_weight_g ~ '^\d+(\.\d+)?$'
            THEN product_weight_g::NUMERIC
            ELSE NULL
        END AS product_weight_g,

        CASE
            WHEN product_length_cm ~ '^\d+(\.\d+)?$'
            THEN product_length_cm::NUMERIC
            ELSE NULL
        END AS product_length_cm,

        CASE
            WHEN product_height_cm ~ '^\d+(\.\d+)?$'
            THEN product_height_cm::NUMERIC
            ELSE NULL
        END AS product_height_cm,

        CASE
            WHEN product_width_cm ~ '^\d+(\.\d+)?$'
            THEN product_width_cm::NUMERIC
            ELSE NULL
        END AS product_width_cm

    FROM raw.products
),

deduplicated_products AS (

    SELECT
        product_id,
        product_category_name,
        product_name_length,
        product_description_length,
        product_photos_qty,
        product_weight_g,
        product_length_cm,
        product_height_cm,
        product_width_cm,

        ROW_NUMBER() OVER (
            PARTITION BY product_id
            ORDER BY product_category_name
        ) AS rn

    FROM cleaned_products
)

SELECT
    product_id,
    product_category_name,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm

FROM deduplicated_products

WHERE rn = 1;