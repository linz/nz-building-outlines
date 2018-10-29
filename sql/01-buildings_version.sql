
-- API that provides version of buildings schema installed in the database

CREATE OR REPLACE FUNCTION buildings.buildings_version()
    RETURNS text
AS $$

    SELECT 'dev'::text;

$$ LANGUAGE 'sql'
IMMUTABLE STRICT;
