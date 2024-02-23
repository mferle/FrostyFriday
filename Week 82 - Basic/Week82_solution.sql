--create a ‘starting stage’
create stage week_82_stage;

--upload the file to that ‘starting stage’
-- done manually via the UI

-- view contents of stage
list @week_82_stage;

--delete the local file
-- done manually in the file system

--move the file from the ‘starting stage’ into a new stage without downloading it!

-- create a new stage
create stage week_82_stage_new;

-- move the file from the starting stage to the new stage

-- first copy the file from the starting stage to the new stage
-- https://docs.snowflake.com/en/sql-reference/sql/copy-files
copy files into @week_82_stage_new from @week_82_stage;

-- check that the file appears in the new stage
list @week_82_stage_new;

-- remove the file from the starting stage
remove @week_82_stage;

-- check that the file is removed from the starting stage
list @week_82_stage;

