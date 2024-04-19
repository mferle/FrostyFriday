-- get the training data:
CREATE STAGE IF NOT EXISTS frosty_aws_stage
  URL = 's3://frostyfridaychallenges/';

CREATE OR REPLACE TABLE WEEK_90 AS 
SELECT 
    $1::TIMESTAMP_NTZ AS SALE_DATE, 
    $2::INT AS PRODUCT_ID,
    $3::INT AS QUANTITY_SOLD,
    $4::INT AS UNIT_PRICE,
    $5/100::FLOAT AS TAX_PCT,
    $6/100::FLOAT AS DCT_PCT
FROM @FROSTY_AWS_STAGE/challenge_90
WHERE $1 != 'Date';

-- data on which to forecast
CREATE OR REPLACE TABLE WEEK_90_F LIKE WEEK_90;
ALTER TABLE WEEK_90_F DROP COLUMN QUANTITY_SOLD;

INSERT INTO WEEK_90_F VALUES 
(TO_TIMESTAMP_NTZ('2023-10-29'), 1000, 450, 0.1, 0.02),
(TO_TIMESTAMP_NTZ('2023-10-29'), 1001, 150, 0.15, 0.02),
(TO_TIMESTAMP_NTZ('2023-10-29'), 1002, 100, 0.13, 0.18),
(TO_TIMESTAMP_NTZ('2023-10-29'), 1003, 170, 0.11, 0.03),
(TO_TIMESTAMP_NTZ('2023-10-29'), 1004, 300, 0.04, 0.03);


-- train the forecast model on training data, using the SERIES_COLNAME parameter to differentiate between the products
CREATE OR REPLACE SNOWFLAKE.ML.FORECAST forecast_model (
    INPUT_DATA => SYSTEM$REFERENCE('TABLE', 'WEEK_90'),
    SERIES_COLNAME => 'PRODUCT_ID',
    TIMESTAMP_COLNAME => 'SALE_DATE',
    TARGET_COLNAME => 'QUANTITY_SOLD'
);

-- forecast using the trained model on the forecast data
call forecast_model!FORECAST(
  INPUT_DATA => SYSTEM$REFERENCE('TABLE', 'WEEK_90_F'),
  SERIES_COLNAME => 'PRODUCT_ID',
  TIMESTAMP_COLNAME =>'SALE_DATE'
);