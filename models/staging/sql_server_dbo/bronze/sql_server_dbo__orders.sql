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
        address_id,
        user_id,
        promo_id,
        tracking_id,
        status AS status_delivery,
        shipping_service,
        shipping_cost,
        created_at,
        delivered_at,
        estimated_delivery_at,
        order_cost,
        order_total
    FROM src_orders
)

SELECT * FROM renamed_casted