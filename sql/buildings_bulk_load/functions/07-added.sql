--------------------------------------------
-- buildings_bulk_load.added

-- Functions:
-- added_select_by_dataset (select from added by dataset)
    -- params: integer
    -- return: integer[] bulk_load_outline_id
-- added_delete_bulk_load_outline (delete from added by bulk_load_outline_id)
    -- params: integer bulk_load_outline_id
    -- return: bulk_load_outline_id that was deleted
-- added_insert_bulk_load_outlines (insert bulk load outline into added table)
    -- params: integer bulk_load_outline_id
    -- return: bulk_load_outline_id added
--------------------------------------------

-- Functions

-- added_select_by_dataset (select from added by dataset)
    -- params: integer
    -- return: integer[] bulk_load_outline_id
CREATE OR REPLACE FUNCTION buildings_bulk_load.added_select_by_dataset(integer)
    RETURNS integer[] AS
$$
    SELECT ARRAY(
        SELECT bulk_load_outline_id
        FROM buildings_bulk_load.added
        JOIN buildings_bulk_load.bulk_load_outlines supplied USING (bulk_load_outline_id)
        WHERE supplied.supplied_dataset_id = $1
            AND supplied.bulk_load_status_id != 3
    );
$$ LANGUAGE sql;
COMMENT ON FUNCTION buildings_bulk_load.added_select_by_dataset(integer) IS
'Select bulk_load_outline_id in added table';


-- added_delete_bulk_load_outline (delete from added by bulk_load_outline_id)
    -- params: integer bulk_load_outline_id
    -- return: bulk_load_outline_id that was deleted
CREATE OR REPLACE FUNCTION buildings_bulk_load.added_delete_bulk_load_outlines(integer)
RETURNS integer AS
$$

    DELETE FROM buildings_bulk_load.added
    WHERE bulk_load_outline_id = $1
    RETURNING bulk_load_outline_id;

$$
LANGUAGE sql;


-- added_insert_bulk_load_outlines (insert bulk load outline into added table)
    -- params: integer bulk_load_outline_id
    -- return: bulk_load_outline_id added
CREATE OR REPLACE FUNCTION buildings_bulk_load.added_insert_bulk_load_outlines(integer)
RETURNS integer AS
$$
    INSERT INTO buildings_bulk_load.added (bulk_load_outline_id, qa_status_id)
    VALUES ($1, 2)
    RETURNING added.bulk_load_outline_id;

$$
LANGUAGE sql;
