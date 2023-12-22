create application role if not exists app_role;
create or alter versioned schema app_schema;
grant usage on schema app_schema to application role app_role;
create or replace streamlit app_schema.streamlit from '/streamlit' main_file='streamlit.py';

-- create the update reference callback here

grant usage on streamlit app_schema.streamlit to application role app_role;


CREATE PROCEDURE APP_SCHEMA.UPDATE_REFERENCE(ref_name STRING, operation STRING, ref_or_alias STRING)
  RETURNS STRING
  LANGUAGE SQL
  AS $$
    BEGIN
      CASE (operation)
        WHEN 'ADD' THEN
          SELECT SYSTEM$SET_REFERENCE(:ref_name, :ref_or_alias);
        WHEN 'REMOVE' THEN
          SELECT SYSTEM$REMOVE_REFERENCE(:ref_name);
        WHEN 'CLEAR' THEN
          SELECT SYSTEM$REMOVE_REFERENCE(:ref_name);
      ELSE
        RETURN 'unknown operation: ' || operation;
      END CASE;
      RETURN NULL;
    END;
  $$;

grant usage on procedure app_schema.update_reference(string, string, string) to application role app_role;
