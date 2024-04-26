-- create role data_engineer
USE ROLE securityadmin;
CREATE ROLE data_engineer;

-- grant the role to myself so I can test it
SET my_current_user = current_user();
GRANT ROLE data_engineer TO USER IDENTIFIER($my_current_user);

-- grant create integration to the data_engineer role
GRANT CREATE INTEGRATION ON ACCOUNT TO ROLE data_engineer;
-- but for some reason it says Grant not executed: Insufficient privileges ??? SECURITYADMIN has no privileges to grant?
-- trying with accountadmin
USE ROLE accountadmin;
GRANT CREATE INTEGRATION ON ACCOUNT TO ROLE data_engineer;
-- ok, this works apparently, moving on

-- grant create database privilege to the data_engineer role
USE ROLE sysadmin;
GRANT CREATE DATABASE ON ACCOUNT TO ROLE data_engineer;
-- create a warehouse and grant usage to the data engineer
CREATE WAREHOUSE pop_wh;
GRANT USAGE ON WAREHOUSE pop_wh TO ROLE data_engineer;

-- use the data engineer role to create a database, a schema, and the startup table
USE ROLE data_engineer;
USE WAREHOUSE pop_wh;
CREATE DATABASE population_db;
CREATE SCHEMA pop_data;

-- startup code
CREATE OR REPLACE TABLE people (
id INTEGER,
name VARCHAR
);

INSERT INTO people (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'David'),
(5, 'Eva'),
(6, 'Fiona'),
(7, 'George'),
(8, 'Hannah'),
(9, 'Ian'),
(10, 'Julia');

-- create an API integration
CREATE OR REPLACE API INTEGRATION git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/FrostyFridays')
  ENABLED = TRUE;

-- create the git repository
CREATE OR REPLACE GIT REPOSITORY ff91
  API_INTEGRATION = git_api_integration
  ORIGIN = 'https://github.com/FrostyFridays/FF_week_91.git';

-- do a fetch to update (although not needed because we just created the repository, should be up to date)
ALTER GIT REPOSITORY ff91 FETCH;

-- check branches
SHOW GIT BRANCHES IN ff91;

-- see what's inside
LS @ff91/branches/main;

-- now create a stored procedure that uses the python code in the git repository as the handler
CREATE OR REPLACE PROCEDURE add1(table_name VARCHAR, column_name VARCHAR)
  RETURNS TABLE()
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.8'
  PACKAGES = ('snowflake-snowpark-python')
  IMPORTS = ('@ff91/branches/main/add_1.py')
  HANDLER = 'add_1.add_one_to_column';

-- execute the procedure
call add1('PEOPLE', 'ID');

-- it works! this is the output:
/*
Alice	2
Bob 	3
Charlie	4
David	5
Eva 	6
Fiona	7
George	8
Hannah	9
Ian 	10
Julia	11
*/