











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
'Update end_lifespan in building outlines table';

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
'Update end_lifespan in buildings table';

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
'Create new added records in building outlines table';

-------------------------------------------------------------------
--BUILDING OUTLINES create new records
-------------------------------------------------------------------
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
COMMENT ON FUNCTION buildings.building_outlines_add_matched_record(integer) IS
'Create new matched records in building outlines table';

-------------------------------------------------------------------
--BUILDING OUTLINES create new records
-------------------------------------------------------------------
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
COMMENT ON FUNCTION buildings.building_outlines_add_related_record(integer, integer) IS
'Create new related records in building outlines table';

-------------------------------------------------------------------
--LIFECYCLE create new records
-------------------------------------------------------------------
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
COMMENT ON FUNCTION buildings.lifecycle_add_record(integer, integer) IS
'Create new records in lifecycle table';