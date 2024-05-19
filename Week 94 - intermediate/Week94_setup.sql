--Create a sql script that using Jinja2 templating that does the following based on my input :
use role sysadmin;
create warehouse ff_wh;
create database ff;
create schema week_94;
create stage setup_stage;

-- upload the setup_env_made_by_intern.sql script to the stage using the Snowsight UI 
-- alternatively use the PUT command

-- execute the script from the stage providing the DEPLOYMENT_TYPE as the parameter
-- first for prod 
EXECUTE IMMEDIATE FROM @setup_stage/setup_env_made_by_intern.sql
USING (DEPLOYMENT_TYPE => 'prod');

-- then for non-prod
EXECUTE IMMEDIATE FROM @setup_stage/setup_env_made_by_intern.sql
USING (DEPLOYMENT_TYPE => 'non-prod');
