-- Revert buildings:buildings_reference/functions/lake_polygons from pg

BEGIN;

DROP FUNCTION buildings_reference.lake_polygons_delete_by_external_id(integer);

DROP FUNCTION buildings_reference.lake_polygons_insert(integer, varchar);

DROP FUNCTION buildings_reference.lake_polygons_update_shape_by_external_id(integer, varchar);

COMMIT;
