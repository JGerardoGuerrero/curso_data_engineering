{{
  config(
    materialized='view'
  )
}}

WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
),

renamed_casted AS (
    SELECT
        {{dbt_utils.generate_surrogate_key(['user_id'])}} AS users_id,
        first_name,
        last_name,
        phone_number,
        {{dbt_utils.generate_surrogate_key(['address_id'])}} AS address_id,
        email,
        created_at,
        updated_at
    FROM src_users
)

SELECT * FROM renamed_casted