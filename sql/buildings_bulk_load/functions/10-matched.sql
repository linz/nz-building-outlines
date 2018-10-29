--------------------------------------------
-- buildings_bulk_load.matched

-- Functions:
--matched_select_by_dataset (select matched bulk loaded outline ids by supplied_dataset_id)
    -- params: integer supplied_dataset_id
    -- return: integer[] bulk_load_outline_ids
-- building_outlines_matched_select_by_dataset (select matched building outline ids by supplied_dataset_id)
    -- params: integer supplied_dataset_id
    -- return: integer[] building_outline_id
-- matched_find_building_id (select building_id by matched bulk_load_outline_id)
    -- params: integer bulk_load_outline_id
    -- return: integer building_id
-- matched_delete_existing_outlines (delete by building outline id, returning deleted building outline id)
    -- params: integer building_outline_id
    -- return: integer building_outline_id
-- matched_insert_building_outlines (insert new match returning building outline id of new entry)
    -- params: integer bulk_load_outline_id, integer building_outline_id
    -- return: integer building_outline_id

--------------------------------------------

-- Functions

--matched_select_by_dataset (select matched bulk loaded outline ids by supplied_dataset_id)
    -- params: integer supplied_dataset_id
    -- return: integer[] bulk_load_outline_ids
CREATE OR REPLACE FUNCTION buildings_bulk_load.matched_select_by_dataset(integer)
    RETURNS integer[] AS
$$
    SELECT ARRAY(
        SELECT bulk_load_outline_id
        FROM buildings_bulk_load.matched
        JOIN buildings_bulk_load.bulk_load_outlines supplied USING (bulk_load_outline_id)
        WHERE supplied.supplied_dataset_id = $1
            AND supplied.bulk_load_status_id != 3
    );
$$ LANGUAGE sql;
COMMENT ON FUNCTION buildings_bulk_load.matched_select_by_dataset(integer) IS
'Select bulk_load_outline_id in matched table';


-- building_outlines_matched_select_by_dataset (select matched building outline ids by supplied_dataset_id)
    -- params: integer supplied_dataset_id
    -- return: integer[] building_outline_id
CREATE OR REPLACE FUNCTION buildings_bulk_load.building_outlines_matched_select_by_dataset(integer)
    RETURNS integer[] AS
$$
    SELECT ARRAY(
        SELECT matched.building_outline_id
        FROM buildings_bulk_load.matched
        WHERE matched.bulk_load_outline_id = $1
    );
$$ LANGUAGE sql;
COMMENT ON FUNCTION buildings_bulk_load.building_outlines_matched_select_by_dataset(integer) IS
'Select building_outline_id in matched table';


-- matched_find_building_id (select building_id by matched bulk_load_outline_id)
    -- params: integer bulk_load_outline_id
    -- return: integer building_id
CREATE OR REPLACE FUNCTION buildings_bulk_load.matched_find_building_id(integer)
    RETURNS integer AS
$$

    SELECT outlines.building_id
    FROM buildings.building_outlines outlines
    JOIN buildings_bulk_load.matched USING (building_outline_id)
    WHERE matched.bulk_load_outline_id = $1

$$ LANGUAGE sql;
COMMENT ON FUNCTION buildings_bulk_load.matched_find_building_id(integer) IS
'Return the building_id of the matched building outlines';


-- matched_delete_existing_outlines (delete by building outline id, returning deleted building outline id)
    -- params: integer building_outline_id
    -- return: integer building_outline_id
CREATE OR REPLACE FUNCTION buildings_bulk_load.matched_delete_existing_outlines(integer)
RETURNS integer AS
$$

    DELETE FROM buildings_bulk_load.matched
    WHERE building_outline_id = $1
    RETURNING building_outline_id;

$$
LANGUAGE sql;


-- matched_insert_building_outlines (insert new match returning building outline id of new entry)
    -- params: integer bulk_load_outline_id, integer building_outline_id
    -- return: integer building_outline_id
CREATE OR REPLACE FUNCTION buildings_bulk_load.matched_insert_building_outlines(integer, integer)
RETURNS integer AS
$$

    INSERT INTO buildings_bulk_load.matched (bulk_load_outline_id, building_outline_id, qa_status_id)
    VALUES ($1, $2, 2)
    RETURNING matched.building_outline_id;

$$
LANGUAGE sql;
