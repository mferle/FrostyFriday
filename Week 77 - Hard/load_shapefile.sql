grant usage on warehouse compute_wh to role sysadmin;
use role sysadmin;
create database geo_db;
use database geo_db;
create schema railways;
use schema railways;
create stage shapefile_stg;

-- manually upload file italy-railways-shape.zip into the stage

-- use code from this blog: https://medium.com/snowflake/load-shapefiles-into-snowflake-the-easy-way-2af966a17c9a

CREATE OR REPLACE FUNCTION PY_LOAD_GEOFILE(PATH_TO_FILE string, FILENAME string)
returns table (wkb binary, properties object)
language python
runtime_version = 3.8
packages = ('fiona', 'shapely', 'snowflake-snowpark-python')
handler = 'GeoFileReader'
AS $$
from shapely.geometry import shape
from snowflake.snowpark.files import SnowflakeFile
from fiona.io import ZipMemoryFile
class GeoFileReader:        
    def process(self, PATH_TO_FILE: str, filename: str):
     with SnowflakeFile.open(PATH_TO_FILE, 'rb') as f:
      with ZipMemoryFile(f) as zip:
       with zip.open(filename) as collection:
        for record in collection:
         if (not (record['geometry'] is None)):
          yield ((shape(record['geometry']).wkb, dict(record['properties'])))
$$;

SELECT 
properties,
to_geography(wkb, True) as geography
FROM 
    table(PY_LOAD_GEOFILE
            (build_scoped_file_url
                (@GEO_DB.RAILWAYS.SHAPEFILE_STG, 'italy-railways-shape.zip'),
                                          'railways.shp')
);

