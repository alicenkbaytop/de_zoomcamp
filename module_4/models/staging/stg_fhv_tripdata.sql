{{
    config(
        materialized='view'
    )
}}

with tripdata as 
(
    
  select *
  from {{ source('staging','fhv_tripdata_2019') }}

)
select
-- identifiers   
{{ dbt.safe_cast("dispatching_base_num", api.Column.translate_type("string")) }} as dispatching_base_num,
{{ dbt.safe_cast("affiliated_base_number", api.Column.translate_type("string")) }} as affiliated_base_number,
{{ dbt.safe_cast("p_ulocation_id", api.Column.translate_type("integer")) }} as pickup_locationid,
{{ dbt.safe_cast("d_olocation_id", api.Column.translate_type("integer")) }} as dropoff_locationid,
{{ dbt.safe_cast("sr_flag", api.Column.translate_type("integer")) }} as shared_trips_flag,

-- timestamps
cast(pickup_datetime as timestamp) as pickup_datetime,
cast(drop_off_datetime as timestamp) as dropoff_datetime

from tripdata
