-- Deploy buildings:buildings_reference/functions/river_polygons to pg

BEGIN;

--------------------------------------------
-- buildings_reference.river_polygons

-- Functions

-- river_polygons_delete_by_external_id
    -- params: integer external_river_polygon_id
    -- return: integer river_polygon_id

-- river_polygons_insert
    -- params: integer external_river_polygon_id, varchar geometry
    -- return: integer river_polygon_id


--------------------------------------------

-- Functions

-- river_polygons_delete_by_external_id ()
    -- params: integer external_river_polygon_id
    -- return: integer river_polygon_id

CREATE OR REPLACE FUNCTION buildings_reference.river_polygons_delete_by_external_id(integer)
RETURNS integer AS
$$
    DELETE FROM buildings_reference.river_polygons
    WHERE external_river_polygon_id = $1
    RETURNING river_polygon_id;

$$
LANGUAGE sql VOLATILE;

COMMENT ON FUNCTION buildings_reference.river_polygons_delete_by_external_id(integer) IS
'Delete from river polygons table by external id';


-- river_polygons_insert
    -- params: integer external_river_polygon_id, varchar geometry
    -- return: integer river_polygon_id

CREATE OR REPLACE FUNCTION buildings_reference.river_polygons_insert(integer, varchar)
RETURNS integer AS
$$
    INSERT INTO buildings_reference.river_polygons (external_river_polygon_id, shape)
    VALUES ($1, ST_SetSRID(ST_GeometryFromText($2), 2193))
    RETURNING river_polygon_id;

$$
LANGUAGE sql VOLATILE;

COMMENT ON FUNCTION buildings_reference.river_polygons_insert(integer, varchar) IS
'Insert new entry into river polygons table';


-- rriver_polygons_update_shape_by_external_id
    -- params: integer external_river_polygon_id, varchar geometry
    -- return: integer river_polygon_id

CREATE OR REPLACE FUNCTION buildings_reference.river_polygons_update_shape_by_external_id(integer, varchar)
RETURNS integer AS
$$
    UPDATE buildings_reference.river_polygons
    SET shape = ST_SetSRID(ST_GeometryFromText($2), 2193)
    WHERE external_river_polygon_id = $1
    RETURNING river_polygon_id;

$$
LANGUAGE sql VOLATILE;

COMMENT ON FUNCTION buildings_reference.river_polygons_update_shape_by_external_id(integer, varchar) IS
'Update geometry of river based on external_river_polygon_id';

COMMIT;
