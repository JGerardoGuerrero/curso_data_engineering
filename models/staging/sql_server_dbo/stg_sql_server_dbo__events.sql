{{
  config(
    materialized='view'
  )
}}

WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }}
),

renamed_casted AS (
    SELECT
        event_id,
        user_id,
        {{dbt_utils.generate_surrogate_key(['order_id'])}} AS order_id,
        page_url,
        event_type,
        product_id,
        session_id,
        created_at
    FROM src_events
)

SELECT * FROM renamed_casted