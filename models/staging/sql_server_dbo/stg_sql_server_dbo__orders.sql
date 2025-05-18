{{
  config(
    materialized='view'
  )
}}

WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
),

renamed_casted AS (

    SELECT
        {{dbt_utils.generate_surrogate_key(['order_id'])}} AS order_id,
        {{dbt_utils.generate_surrogate_key(['address_id'])}} AS address_id,
        user_id,
        CASE 
        WHEN promo_id IS NULL OR TRIM(promo_id) = '' THEN 'no promo'
        ELSE promo_id
        END AS promo_id,
        created_at,
        order_cost,
        order_total
    FROM src_orders
)

SELECT * FROM renamed_casted