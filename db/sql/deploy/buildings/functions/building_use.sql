-- Deploy nz-buildings:buildings/functions/building_use to pg

BEGIN;

--------------------------------------------
-- buildings.building_use

-- use_update_end_lifespan (update the end_endlifespan of building in use table)
    -- params: integer[], building_ids
    -- return: number of outlines updated
--------------------------------------------

-- Functions

-- building_use_update_end_lifespan (update the end_endlifespan of building in use table)
    -- params: integer[], building_ids
    -- return: number of outlines updated

CREATE OR REPLACE FUNCTION buildings.building_use_update_end_lifespan(integer[])
RETURNS integer AS
$$

    WITH update_use AS (
        UPDATE buildings.building_use
        SET end_lifespan = now()
        WHERE building_id = ANY($1)
        RETURNING *
    )
    SELECT count(*)::integer FROM update_use;

$$
LANGUAGE sql VOLATILE;

COMMENT ON FUNCTION buildings.building_use_update_end_lifespan(integer[]) IS
'Update end_lifespan in building use table';

COMMIT;
