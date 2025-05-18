{{
  config(
    materialized='view'
  )
}}

WITH src_order_items AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'order_items') }}
),

renamed_casted AS (
    SELECT
        {{dbt_utils.generate_surrogate_key(['order_id'])}} AS order_id,
        product_id,
        quantity AS quantity_products
    FROM src_order_items
)

SELECT * FROM renamed_casted