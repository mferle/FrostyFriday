-- use SnowSQL to put file into internal user stage
-- select only files that end with *1.csv
put file://C:\data_batch\*1.csv @~;

-- go to a worksheet
-- list the user stage
list @~;

-- create target table
create table users (
id integer,
first_name varchar,
last_name varchar,
email varchar,
gender varchar,
ip varchar
);

-- copy into target table from user stage
copy into users
from (select $1, $2, $3, $4, $5, $6 from @~)
FILE_FORMAT = ( TYPE = CSV skip_header = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"')
ON_ERROR = SKIP_FILE;
