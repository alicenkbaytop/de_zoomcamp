-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `ny_taxi.external_green_tripdata`
OPTIONS (
  format = 'parquet',
  uris = ['gs://nyc-tlc-green-taxi-trip/green_tripdata_2022-*.parquet']
);

-- Create a table using the Green Taxi Trip Records for 2022 (do not partition or cluster this table).
CREATE OR REPLACE TABLE nifty-time-412619.ny_taxi.green_tripdata_non_partitoned AS
SELECT * FROM nifty-time-412619.ny_taxi.external_green_tripdata;

-- count of records for the 2022 Green Taxi Data
SELECT COUNT(*) FROM nifty-time-412619.ny_taxi.external_green_tripdata;

-- Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
-- What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?
SELECT COUNT(DISTINCT PULocationID) FROM nifty-time-412619.ny_taxi.external_green_tripdata;

SELECT COUNT(DISTINCT PULocationID) FROM nifty-time-412619.ny_taxi.green_tripdata_non_partitoned;

-- Records with a fare_amount of 0
SELECT COUNT (*) FROM nifty-time-412619.ny_taxi.external_green_tripdata
WHERE fare_amount = 0;

--Partition by lpep_pickup_datetime Cluster on PUlocationID
CREATE OR REPLACE TABLE nifty-time-412619.ny_taxi.green_tripdata_partitoned
PARTITION BY
  DATE(lpep_pickup_datetime)
  CLUSTER BY PULocationID AS
SELECT * FROM nifty-time-412619.ny_taxi.green_tripdata_non_partitoned;

-- Write a query to retrieve the distinct PULocationID between lpep_pickup_datetime 06/01/2022 and 06/30/2022 (inclusive)
-- Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 4 and note the estimated bytes processed. What are these values?
-- 0 MB processed
SELECT DISTINCT PULocationID FROM nifty-time-412619.ny_taxi.green_tripdata_partitoned
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';
-- 12.82 MB processed
SELECT DISTINCT PULocationID FROM nifty-time-412619.ny_taxi.green_tripdata_non_partitoned
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';