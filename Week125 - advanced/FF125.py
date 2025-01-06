from snowflake.snowpark.session import Session
session = Session.builder.config("connection_name", "my_connection").create()

session.file.put("main.sql", "@my_files_stage", auto_compress=False, overwrite=True)
session.file.put("utils.sql", "@my_files_stage", auto_compress=False, overwrite=True)
session.close()

#EXECUTE IMMEDIATE FROM @aoc_files_stage/main.sql;
