-- Deploy buildings:buildings_bulk_load/functions/supplied_outlines to pg

BEGIN;

--------------------------------------------
-- buildings_bulk_load.supplied_outlines

-- Functions:

-- supplied_outlines_insert (Insert into buildings_bulk_load.supplied_outlines)
    -- params: integer supplied_dataset_id, integer external_outline_id, geometry shape
    -- return: integer supplied_outline_id

--------------------------------------------

-- Functions


-- supplied_outlines_insert (Insert into buildings_bulk_load.supplied_outlines)
    -- params: integer supplied_dataset_id, integer external_outline_id, geometry shape
    -- return: integer supplied_outline_id

CREATE OR REPLACE FUNCTION buildings_bulk_load.supplied_outlines_insert(
      p_supplied_dataset_id integer
    , p_external_outline_id integer
    , p_shape geometry
)
RETURNS integer AS
$$

    INSERT INTO buildings_bulk_load.supplied_outlines(
          supplied_outline_id
        , supplied_dataset_id
        , external_outline_id
        , begin_lifespan
        , shape
    )
    VALUES (
          DEFAULT -- sequence
        , p_supplied_dataset_id
        , p_external_outline_id
        , now()
        , p_shape
    )
    RETURNING supplied_outline_id;

$$
LANGUAGE sql VOLATILE;

COMMENT ON FUNCTION buildings_bulk_load.supplied_outlines_insert(integer, integer, geometry) IS
'Insert new outlines into supplied outlines table';

COMMIT;
