{{
  config(
    materialized='view'
  )
}}

WITH src_budget AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget') }}
    ),

renamed_casted AS (
    SELECT
        {{dbt_utils.generate_surrogate_key(['product_id', 'month'])}} AS budget_id
        , {{dbt_utils.generate_surrogate_key(['product_id'])}} AS product_id
        , quantity AS budget_quantity
        , month AS monthly_date
    FROM src_budget
    )

SELECT * FROM renamed_casted