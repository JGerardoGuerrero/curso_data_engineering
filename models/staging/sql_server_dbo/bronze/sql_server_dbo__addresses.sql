{{
  config(
    materialized='view'
  )
}}

WITH src_addresses AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }}
    ),

renamed_casted AS (
    SELECT
        address_id
        , LPAD(zipcode, 5, '0') as zipcode
        , country
        , address
        , state
    FROM src_addresses
    )

SELECT * FROM renamed_casted