-- Verify nz-buildings:buildings_reference/functions/protected_area_polygons on pg

BEGIN;

SELECT has_function_privilege('buildings_reference.protected_areas_delete_by_external_id(integer)', 'execute');

SELECT has_function_privilege('buildings_reference.protected_areas_insert(integer, varchar)', 'execute');

SELECT has_function_privilege('buildings_reference.protected_areas_update_shape_by_external_id(integer, varchar)', 'execute');

ROLLBACK;
