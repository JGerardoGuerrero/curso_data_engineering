--genera una "tabla" con año, día y mes de 2021-01-01 a 2025-12-31

{{
    config(
        materialized = "view"
    )
}}

{{ dbt_date.get_date_dimension("2021-01-01", "2025-12-31") }}