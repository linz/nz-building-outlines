-- Verify nz-buildings:buildings_bulk_load/functions/compare on pg

BEGIN;

SELECT has_function_privilege('buildings_bulk_load.find_added(integer)', 'execute');

SELECT has_function_privilege('buildings_bulk_load.find_removed(integer)', 'execute');

SELECT has_function_privilege('buildings_bulk_load.find_matched(integer)', 'execute');

SELECT has_function_privilege('buildings_bulk_load.find_related(integer)', 'execute');

SELECT has_function_privilege('buildings_bulk_load.reassign_related_ids(integer)', 'execute');

SELECT has_function_privilege('buildings_bulk_load.compare_building_outlines(integer)', 'execute');

DO $$
BEGIN
 
    PERFORM proname, proargnames, prosrc
    FROM pg_proc
    WHERE proname = 'compare_building_outlines'
    AND prosrc LIKE '%buildings_bulk_load.removed (building_outline_id, qa_status_id, supplied_dataset_id)%';
 
    IF NOT FOUND THEN
        RAISE EXCEPTION 'supplied_dataset_id insert into removed table not found.';
    END IF;
 
END $$;

ROLLBACK;
