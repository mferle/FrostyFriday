create or replace table images (file_name string, image_bytes string);

-- download the csv file from the S3 bucket
-- upload the csv file to the table in Snowsight