-- Verify nz-buildings:buildings_bulk_load/functions/removed on pg

BEGIN;

SELECT has_function_privilege('buildings_bulk_load.building_outlines_removed_select_by_dataset(integer)', 'execute');

SELECT has_function_privilege('buildings_bulk_load.buildings_removed_select_by_dataset(integer)', 'execute');

SELECT has_function_privilege('buildings_bulk_load.removed_delete_existing_outline(integer)', 'execute');

SELECT has_function_privilege('buildings_bulk_load.removed_delete_existing_outlines(integer[])', 'execute');

SELECT has_function_privilege('buildings_bulk_load.removed_insert_building_outlines(integer)', 'execute');

SELECT has_function_privilege('buildings_bulk_load.removed_update_qa_status_id(integer, integer)', 'execute');

DO $$
BEGIN
 
    PERFORM proname, proargnames, prosrc
    FROM pg_proc
    WHERE proname = 'removed_insert_building_outlines'
    AND prosrc LIKE '%buildings_bulk_load.removed(building_outline_id, qa_status_id, supplied_dataset_id)%';
 
    IF NOT FOUND THEN
        RAISE EXCEPTION 'supplied_dataset_id insert into removed table not found.';
    END IF;
 
END $$;

ROLLBACK;
