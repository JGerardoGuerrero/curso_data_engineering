{{
  config(
    materialized='view'
  )
}}

WITH src_order_items AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'order_items') }}
),

src_products AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'products') }}
),

dim_products AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} AS product_id,
        price,
        name AS name_product
    FROM src_products
),

order_items_base AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['order_id']) }} AS order_id,
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} AS product_id,
        quantity AS quantity_products
    FROM src_order_items
),

order_items_completed AS (
    SELECT
        oi.order_id,
        oi.product_id,
        oi.quantity_products,
        dp.name_product,
        dp.price
    FROM order_items_base oi
    LEFT JOIN dim_products dp
        ON oi.product_id = dp.product_id
)

SELECT * FROM order_items_completed