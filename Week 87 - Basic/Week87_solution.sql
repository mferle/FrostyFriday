CREATE OR REPLACE TABLE WEEK_87 AS
SELECT 
  'Happy Easter' AS greeting,
  ARRAY_CONSTRUCT('DE', 'FR', 'IT', 'ES', 'PL', 'RO', 'JA', 'KO', 'PT') AS language_codes
;

-- use the CORTEX translate function to translate the greeting in each of the languages in the array
select 
  value::varchar as language_code, 
  SNOWFLAKE.CORTEX.TRANSLATE(greeting, 'en', value) as translated_greeting
from WEEK_87,
lateral flatten(input => language_codes);
