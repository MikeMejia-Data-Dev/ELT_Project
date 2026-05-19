# ShopWave ELT — Data Profiling Report

## Overview

This document contains the profiling analysis performed on the RAW layer of the ShopWave ELT pipeline.

The objective of this phase is to identify:
- null values
- duplicate records
- malformed data
- invalid numeric formats
- referential integrity issues
- data quality risks

The RAW layer remains immutable.
No modifications are applied during profiling.

---

# Tables Analyzed

- raw.orders
- raw.order_items
- raw.customers
- raw.products

---

# 1. raw.orders

## Row Count

| Metric | Value |
|---|---|
| Total Rows | 99441 |

# 2. raw.order_items

## Row Count

| Metric | Value |
|---|---|
| Total Rows | 0 |

# 3. raw.customers

## Row Count

| Metric | Value |
|---|---|
| Total Rows | 99441 |


# 4. raw.products

## Row Count

| Metric | Value |
|---|---|
| Total Rows | 32951 |

---

## Duplicate Analysis

### Query

```sql

-- ORDERS

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

--CUSTOMERS

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

-- ORDER_ITEMS

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

--PRODUCTS

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
```

## Duplicate Analysis

### Findings

No exact duplicate rows detected in `raw.order_items`.

| Metric | Value |
|---|---|
| Exact Duplicate Rows | 0 |

### Impact

No evidence of duplicated transactional line items was identified.

This reduces the risk of:
- revenue inflation
- duplicated product sales
- inaccurate aggregations

### Recommended Action

No deduplication required for exact row duplicates.
Continue monitoring during STAGING transformations.