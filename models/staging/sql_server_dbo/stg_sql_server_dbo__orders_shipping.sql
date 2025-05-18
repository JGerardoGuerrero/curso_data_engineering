{{ 
  config(
    materialized='view'
  ) 
}}

WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
),

cleaned AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['order_id']) }} AS order_id,
        
        CASE 
            WHEN tracking_id IS NULL OR TRIM(tracking_id) = '' THEN 'preparing'
            ELSE tracking_id
        END AS tracking_id,
        
        status AS status_delivery,
        
        CASE 
            WHEN shipping_service IS NULL OR TRIM(shipping_service) = '' THEN 'unknown'
            ELSE shipping_service
        END AS shipping_service,
        
        shipping_cost,
        
        NULLIF(TRIM(delivered_at), '') AS delivered_at,
        NULLIF(TRIM(estimated_delivery_at), '') AS estimated_delivery_at

    FROM src_orders
),

final AS (
    SELECT
        *,
        CASE 
            WHEN delivered_at IS NULL THEN 'no delivered'
            WHEN estimated_delivery_at IS NULL AND shipping_service = 'ups' THEN 'more info https://www.ups.com/es/es/support/contact-us'
            WHEN estimated_delivery_at IS NULL AND shipping_service = 'usps' THEN 'more info https://es.usps.com/help/contact-us.htm'
            WHEN estimated_delivery_at IS NULL AND shipping_service = 'dhl' THEN 'more info https://www.dhl.com/es-es/home/servicio-al-cliente.html'
            WHEN estimated_delivery_at IS NULL AND shipping_service = 'fedex' THEN 'more info https://www.fedex.com/es-es/customer-support/contact.html'
            ELSE 'delivered or scheduled'
        END AS shipping_status
    FROM cleaned
)

SELECT * FROM final