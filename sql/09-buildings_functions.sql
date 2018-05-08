-------------------------------------------------------------------
--BUILDING OUTLINES update end_lifespan
-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings.building_outlines_update_end_lifespan(integer[])
    RETURNS integer AS
$$

    WITH update_building_outlines AS (
        UPDATE buildings.building_outlines
        SET end_lifespan = now()
        WHERE building_outline_id = ANY($1)
        RETURNING *
    )
    SELECT count(*)::integer FROM update_building_outlines;

$$ LANGUAGE sql;

COMMENT ON FUNCTION buildings.building_outlines_update_end_lifespan(integer[]) IS
'Update end_lifespan in BUILDING OUTLINES schema';

-------------------------------------------------------------------
--BUILDINGS update end_lifespan
-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings.buildings_update_end_lifespan(integer[])
    RETURNS integer AS
$$

    WITH update_buildings AS (
        UPDATE buildings.buildings
        SET end_lifespan = now()
        WHERE building_id = ANY($1)
        RETURNING *
    )
    SELECT count(*)::integer FROM update_buildings;

$$ LANGUAGE sql;

COMMENT ON FUNCTION buildings.buildings_update_end_lifespan(integer[]) IS
'Update end_lifespan in BUILDINGS schema';

-------------------------------------------------------------------
--REMOVED select by dataset (BUILDING OUTLINES)
-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.building_outlines_removed_select_by_dataset(integer)
    RETURNS integer[] AS
$$

    SELECT ARRAY(
        SELECT removed.building_outline_id
        FROM buildings_bulk_load.removed
        JOIN buildings_bulk_load.existing_subset_extracts current USING (building_outline_id)
        WHERE current.supplied_dataset_id = $1
    )

$$ LANGUAGE sql;

COMMENT ON FUNCTION buildings_bulk_load.building_outlines_removed_select_by_dataset(integer) IS
'Select building_outline_id in removed table';

-------------------------------------------------------------------
--REMOVED select by dataset (BUILDINGS)
-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.buildings_removed_select_by_dataset(integer)
    RETURNS integer[] AS
$$

    SELECT ARRAY(
        SELECT outlines.building_id
        FROM buildings.building_outlines outlines
        JOIN buildings_bulk_load.removed USING (building_outline_id)
        JOIN buildings_bulk_load.existing_subset_extracts current USING (building_outline_id)
        WHERE current.supplied_dataset_id = $1
    )

$$ LANGUAGE sql;

COMMENT ON FUNCTION buildings_bulk_load.buildings_removed_select_by_dataset(integer) IS
'Select building_id in removed table';

-------------------------------------------------------------------
--BUILDINGS create new records
-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings.buildings_add_record()
    RETURNS integer AS
$$
    INSERT INTO buildings.buildings(building_id)
    VALUES ( DEFAULT )
    RETURNING building_id

$$ LANGUAGE sql;

COMMENT ON FUNCTION buildings.buildings_add_record() IS
'Create new records in buildings table';

-------------------------------------------------------------------
--BUILDING OUTLINES create new records
-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings.building_outlines_add_added_record(integer, integer)
    RETURNS integer AS
$$
    INSERT INTO buildings.building_outlines (
          building_id
        , capture_method_id
        , capture_source_id
        , lifecycle_stage_id
        , suburb_locality_id
        , town_city_id
        , territorial_authority_id
        , begin_lifespan
        , shape
    )
    SELECT
          $1
        , supplied.capture_method_id
        , supplied.capture_source_id
        , 1
        , supplied.suburb_locality_id
        , supplied.town_city_id
        , supplied.territorial_authority_id
        , supplied.begin_lifespan
        , supplied.shape
    FROM buildings_bulk_load.bulk_load_outlines supplied
    WHERE supplied.bulk_load_outline_id = $2
    RETURNING building_outline_id;

$$ LANGUAGE sql;
COMMENT ON FUNCTION buildings.building_outlines_add_added_record(integer, integer) IS
'Create new records in building outlines table';

-------------------------------------------------------------------
--TRANSFERRED update
-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.transferred_add_record(integer, integer)
    RETURNS integer AS
$$
    INSERT INTO buildings_bulk_load.transferred(bulk_load_outline_id, new_building_outline_id)
    VALUES($1, $2)
    RETURNING bulk_load_outline_id;

$$ LANGUAGE sql;
COMMENT ON FUNCTION buildings_bulk_load.transferred_add_record(integer, integer) IS
'Update transferred table';

-------------------------------------------------------------------
--ADDED select by dataset
-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.added_select_by_dataset(integer)
    RETURNS integer[] AS
$$
    SELECT ARRAY(
        SELECT bulk_load_outline_id
        FROM buildings_bulk_load.added
        JOIN buildings_bulk_load.bulk_load_outlines supplied USING (bulk_load_outline_id)
        WHERE supplied.supplied_dataset_id = $1
    );
$$ LANGUAGE sql;

-------------------------------------------------------------------
--MATCHED select by dataset
-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.matched_select_by_dataset(integer)
    RETURNS integer[] AS
$$
    SELECT ARRAY(
        SELECT bulk_load_outline_id
        FROM buildings_bulk_load.matched
        JOIN buildings_bulk_load.bulk_load_outlines supplied USING (bulk_load_outline_id)
        WHERE supplied.supplied_dataset_id = $1
    );
$$ LANGUAGE sql;



CREATE OR REPLACE FUNCTION buildings.building_outlines_add_matched_record(integer)
    RETURNS integer AS
$$
    INSERT INTO buildings.building_outlines(
          building_id
        , capture_method_id
        , capture_source_id
        , lifecycle_stage_id
        , suburb_locality_id
        , town_city_id
        , territorial_authority_id
        , begin_lifespan
        , shape
    )
    SELECT
          outlines.building_id
        , supplied.capture_method_id
        , supplied.capture_source_id
        , 1
        , supplied.suburb_locality_id
        , supplied.town_city_id
        , supplied.territorial_authority_id
        , supplied.begin_lifespan
        , supplied.shape
    FROM buildings_bulk_load.bulk_load_outlines supplied
    JOIN buildings_bulk_load.matched USING (bulk_load_outline_id)
    JOIN buildings.building_outlines outlines USING (building_outline_id)
    WHERE supplied.bulk_load_outline_id = $1
    RETURNING building_outline_id;

$$ LANGUAGE sql;



CREATE OR REPLACE FUNCTION buildings_bulk_load.building_outlines_matched_select_by_dataset(integer)
    RETURNS integer[] AS
$$
    SELECT ARRAY(
        SELECT matched.building_outline_id
        FROM buildings_bulk_load.matched
        WHERE matched.bulk_load_outline_id = $1
    );
$$ LANGUAGE sql;



CREATE OR REPLACE FUNCTION buildings_bulk_load.related_select_by_dataset(integer)
    RETURNS integer[] AS
$$
    SELECT ARRAY(
        SELECT DISTINCT bulk_load_outline_id
        FROM buildings_bulk_load.related
        JOIN buildings_bulk_load.bulk_load_outlines supplied USING (bulk_load_outline_id)
        WHERE supplied.supplied_dataset_id = $1
    );

$$ LANGUAGE sql;


CREATE OR REPLACE FUNCTION buildings.building_outlines_add_related_record(integer, integer)
    RETURNS integer AS
$$
    INSERT INTO buildings.building_outlines(
          building_id
        , capture_method_id
        , capture_source_id
        , lifecycle_stage_id
        , suburb_locality_id
        , town_city_id
        , territorial_authority_id
        , begin_lifespan
        , shape
    )
    SELECT
          $1
        , supplied.capture_method_id
        , supplied.capture_source_id
        , 1
        , supplied.suburb_locality_id
        , supplied.town_city_id
        , supplied.territorial_authority_id
        , supplied.begin_lifespan
        , supplied.shape
    FROM buildings_bulk_load.bulk_load_outlines supplied
    WHERE supplied.bulk_load_outline_id = $2
    RETURNING building_outline_id;

$$ LANGUAGE sql;


CREATE OR REPLACE FUNCTION buildings.lifecycle_add_record(integer, integer)
    RETURNS integer AS
$$
    INSERT INTO buildings.lifecycle(
          parent_building_id
        , building_id
    )
    SELECT
          outlines.building_id
        , $1
    FROM buildings_bulk_load.related
    JOIN buildings.building_outlines outlines USING (building_outline_id)
    WHERE related.bulk_load_outline_id = $2
    RETURNING building_id;

$$ LANGUAGE sql;

-------------------------------------------------------------------
--RELATED select by dataset (BUILDING OUTLINES)
-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.building_outlines_related_select_by_dataset(integer)
    RETURNS integer[] AS
$$

    SELECT ARRAY(
        SELECT related.building_outline_id
        FROM buildings_bulk_load.related
        WHERE related.bulk_load_outline_id = $1
    );

$$ LANGUAGE sql;

COMMENT ON FUNCTION buildings_bulk_load.building_outlines_related_select_by_dataset(integer) IS
'Select building_outline_id in related table';

-------------------------------------------------------------------
--RELATED select by dataset (BUILDINGS)
-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.buildings_related_select_by_dataset(integer)
    RETURNS integer[] AS
$$

    SELECT ARRAY(
        SELECT outlines.building_id
        FROM buildings.building_outlines outlines
        JOIN buildings_bulk_load.related USING (building_outline_id)
        WHERE related.bulk_load_outline_id = $1
    );

$$ LANGUAGE sql;

COMMENT ON FUNCTION buildings_bulk_load.buildings_related_select_by_dataset(integer) IS
'Select building_id in related table';


CREATE OR REPLACE FUNCTION buildings_bulk_load.supplied_datasets_update_transfer_date(integer)
    RETURNS integer AS
$$
    WITH update_transfer_date AS (
        UPDATE buildings_bulk_load.supplied_datasets
        SET transfer_date = now()
        WHERE supplied_dataset_id = $1
        RETURNING *
    )
    SELECT count(*)::integer FROM update_transfer_date;

$$ LANGUAGE sql;

-------------------------------------------------------------------
--BUILDINGS insert into
-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings.fn_buildings_insert()
RETURNS integer AS
$$

    INSERT INTO buildings.buildings(
          building_id
        , begin_lifespan
    )
    VALUES (
          DEFAULT -- sequence
        , DEFAULT -- now()
    )
    RETURNING building_id;

$$
LANGUAGE sql VOLATILE;

----------------------------------------------------------------
-- BUILDING OUTLINES insert into
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings.fn_building_outlines_insert(
      p_building_id integer
    , p_capture_method_id integer
    , p_capture_source_id integer
    , p_lifecycle_stage_id integer
    , p_suburb_locality_id integer
    , p_town_city_id integer
    , p_territorial_authority_id integer
    , p_begin_lifespan timestamptz
    , p_shape geometry
)
RETURNS integer AS
$$

    INSERT INTO buildings.building_outlines(
          building_outline_id
        , building_id
        , capture_method_id
        , capture_source_id
        , lifecycle_stage_id
        , suburb_locality_id
        , town_city_id
        , territorial_authority_id
        , begin_lifespan
        , shape
    )
    VALUES (
          DEFAULT -- sequence
        , p_building_id
        , p_capture_method_id
        , p_capture_source_id
        , p_lifecycle_stage_id
        , p_suburb_locality_id
        , p_town_city_id
        , p_territorial_authority_id
        , p_begin_lifespan
        , p_shape
    )
    RETURNING building_outline_id;

$$
LANGUAGE sql VOLATILE;

-------------------------------------------------------------------------
-- LIFECYCLE STAGE insert into
-------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings.fn_lifecycle_stage_insert(
      p_value varchar(40)
)
RETURNS integer AS
$$

    INSERT INTO buildings.lifecycle_stage(
          lifecycle_stage_id
        , value
    )
    VALUES (
          DEFAULT -- sequence
        , p_value

    )
    RETURNING lifecycle_stage_id;

$$
LANGUAGE sql VOLATILE;