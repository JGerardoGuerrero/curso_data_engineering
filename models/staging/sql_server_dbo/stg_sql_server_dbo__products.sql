{{
  config(
    materialized='view'
  )
}}

WITH src_products AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'products') }}
),

renamed_casted AS (
    SELECT
        {{dbt_utils.generate_surrogate_key(['product_id'])}} AS products_id,
        price,
        name AS name_product,
        inventory
    FROM src_products
)

SELECT * FROM renamed_casted