--Question 1
CREATE MATERIALIZED VIEW taxi_trips_stats AS
SELECT
    tz1.zone AS pickup_zone,
    tz2.zone AS dropoff_zone,
    AVG(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) AS avg_trip_time,
    MIN(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) AS min_trip_time,
    MAX(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) AS max_trip_time
FROM
    trip_data td
    JOIN taxi_zone tz1 ON td.pulocationid = tz1.location_id
    JOIN taxi_zone tz2 ON td.dolocationid = tz2.location_id
GROUP BY
    tz1.zone,
    tz2.zone;

SELECT
    pickup_zone,
    dropoff_zone,
    avg_trip_time
FROM
    taxi_trips_stats
ORDER BY
    avg_trip_time DESC
LIMIT
    1;

--Question 2
CREATE MATERIALIZED VIEW taxi_trips_count AS
SELECT
    tz1.zone AS pickup_zone,
    tz2.zone AS dropoff_zone,
    COUNT(*) as number_trips,
    AVG(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) AS avg_trip_time,
    MIN(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) AS min_trip_time,
    MAX(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) AS max_trip_time
FROM
    trip_data td
    JOIN taxi_zone tz1 ON td.pulocationid = tz1.location_id
    JOIN taxi_zone tz2 ON td.dolocationid = tz2.location_id
GROUP BY
    tz1.zone,
    tz2.zone;

SELECT
    number_trips,
    pickup_zone,
    dropoff_zone
FROM
    taxi_trips_count
ORDER BY
    avg_trip_time DESC
LIMIT
    1;

with t as (
    SELECT
        tz1.zone AS pickup_zone,
        tz2.zone AS dropoff_zone,
        td.tpep_dropoff_datetime - td.tpep_pickup_datetime AS trip_diffference
    FROM
        trip_data td
        JOIN taxi_zone tz1 ON td.pulocationid = tz1.location_id
        JOIN taxi_zone tz2 ON td.dolocationid = tz2.location_id
)
SELECT
    pickup_zone,
    dropoff_zone,
    trip_diffference
FROM
    t
ORDER BY
    trip_diffference DESC
LIMIT
    5;

SELECT
    *
FROM
    taxi_trips_count
WHERE
    "pickup_zone" = 'Queensbridge/Ravenswood';

--Question 3
SELECT
    tz.zone as pickup_zone,
    count(*) as number_trips
FROM
    trip_data td
    JOIN taxi_zone tz ON td.pulocationid = tz.location_id
WHERE
    td.tpep_pickup_datetime >= (
        SELECT
            MAX(tpep_pickup_datetime) - interval '17 hours'
        FROM
            trip_data
    )
    AND td.tpep_pickup_datetime <= (
        SELECT
            MAX(tpep_pickup_datetime)
        FROM
            trip_data
    )
GROUP BY
    pickup_zone
ORDER BY
    number_trips DESC
LIMIT
    3;