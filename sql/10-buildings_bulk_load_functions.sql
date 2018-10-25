-------------------------------------------------------------------------
-- SUPPLIED OUTLINES insert into
-------------------------------------------------------------------------
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

-------------------------------------------------------------------------
-- BULK LOAD OUTLINES insert into
-------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.bulk_load_outlines_insert_supplied(
      p_supplied_dataset_id integer
    , p_bulk_load_status_id integer
    , p_capture_method_id integer
    , p_capture_source_id integer
)
RETURNS integer AS
$$

    WITH insert_supplied AS (
        INSERT INTO buildings_bulk_load.bulk_load_outlines(
              supplied_dataset_id
            , external_outline_id
            , bulk_load_status_id
            , capture_method_id
            , capture_source_id
            , suburb_locality_id
            , town_city_id
            , territorial_authority_id
            , begin_lifespan
            , shape
        )
        SELECT
              supplied_dataset_id
            , external_outline_id
            , p_bulk_load_status_id
            , p_capture_method_id
            , p_capture_source_id
            , buildings.suburb_locality_intersect_polygon(shape)
            , buildings.town_city_intersect_polygon(shape)
            , buildings.territorial_authority_grid_intersect_polygon(shape)
            , now()
            , shape
        FROM buildings_bulk_load.supplied_outlines s
        WHERE s.supplied_dataset_id = p_supplied_dataset_id
        RETURNING *
    )
    SELECT count(*)::integer FROM insert_supplied;

$$
LANGUAGE sql VOLATILE;

-------------------------------------------------------------------------
-- BULK LOAD OUTLINES insert into
-------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.bulk_load_outlines_insert(
      p_supplied_dataset_id integer
    , p_external_outline_id integer
    , p_bulk_load_status_id integer
    , p_capture_method_id integer
    , p_capture_source_id integer
    , p_suburb_locality_id integer
    , p_town_city_id integer
    , p_territorial_authority_id integer
    , p_shape geometry
)
RETURNS integer AS
$$

    INSERT INTO buildings_bulk_load.bulk_load_outlines(
          bulk_load_outline_id
        , supplied_dataset_id
        , external_outline_id
        , bulk_load_status_id
        , capture_method_id
        , capture_source_id
        , suburb_locality_id
        , town_city_id
        , territorial_authority_id
        , begin_lifespan
        , shape
    )
    VALUES (
          DEFAULT -- sequence
        , p_supplied_dataset_id
        , p_external_outline_id
        , p_bulk_load_status_id
        , p_capture_method_id
        , p_capture_source_id
        , p_suburb_locality_id
        , p_town_city_id
        , p_territorial_authority_id
        , now()
        , p_shape
    )
    RETURNING bulk_load_outline_id;

$$
LANGUAGE sql VOLATILE;

------------------------------------------------------------------------
-- BUILDINGS BULK LOAD update shape
-- returns the number of shapes updated
------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.bulk_load_outlines_update_shape(geometry, integer)
    RETURNS integer AS
$$
    WITH update_shape AS (
        UPDATE buildings_bulk_load.bulk_load_outlines
        SET shape = $1
        WHERE bulk_load_outline_id = $2
        RETURNING *
    )
    SELECT count(*)::integer FROM update_shape;

$$ LANGUAGE sql VOLATILE;
COMMENT ON FUNCTION buildings_bulk_load.bulk_load_outlines_update_shape(geometry, integer) IS
'Update shape in bulk_load_outlines table';

------------------------------------------------------------------------
-- BUILDINGS BULK LOAD update attributes
-- returns the number of outlines updated
------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.bulk_load_outlines_update_attributes(
      p_bulk_load_outline_id integer
    , p_bulk_load_status_id integer
    , p_capture_method_id integer
    , p_capture_source_id integer
    , p_suburb_locality_id integer
    , p_town_city_id integer
    , p_territorial_authority_id integer
)
    RETURNS integer AS
$$
    WITH update_attributes AS (
        UPDATE buildings_bulk_load.bulk_load_outlines
        SET bulk_load_status_id = $2
        , capture_method_id = $3
        , capture_source_id = $4
        , suburb_locality_id = $5
        , town_city_id = $6
        , territorial_authority_id = $7
        WHERE bulk_load_outline_id = $1
        RETURNING *
    )
    SELECT count(*)::integer FROM update_attributes;

$$ LANGUAGE sql VOLATILE;
COMMENT ON FUNCTION buildings_bulk_load.bulk_load_outlines_update_attributes(integer, integer, integer, integer, integer, integer, integer) IS
'Update attributes in bulk_load_outlines table';

------------------------------------------------------------------------
-- BUILDINGS BULK LOAD update attribute: Capture Method
-- returns the number of outlines updated
------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.bulk_load_outlines_update_capture_method(
      p_bulk_load_outline_id integer
    , p_capture_method_id integer
)
    RETURNS integer AS
$$
    WITH update_capture_method AS(
        UPDATE buildings_bulk_load.bulk_load_outlines
        SET capture_method_id = $2
        WHERE bulk_load_outline_id = $1
        RETURNING *
    )
    SELECT count(*)::integer FROM update_capture_method;

$$ LANGUAGE sql VOLATILE;
COMMENT ON FUNCTION buildings_bulk_load.bulk_load_outlines_update_capture_method(integer, integer) IS
'Update capture method in bulk_load_outlines table';

------------------------------------------------------------------------
-- BUILDINGS BULK LOAD update bulk load status of small buildings (less
-- than 10sqm) to 'Deleted During QA'
-- returns the number of outlines updated
------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.bulk_load_outlines_remove_small_buildings(integer)
    RETURNS integer AS
$$
    WITH small_buildings AS (
        UPDATE buildings_bulk_load.bulk_load_outlines
        SET bulk_load_status_id = 3
        WHERE bulk_load_outline_id in (SELECT
            bulk_load_outline_id
        FROM buildings_bulk_load.bulk_load_outlines
        WHERE ST_Area(shape) < 10)
        AND supplied_dataset_id = $1
        RETURNING *
    )
    SELECT count(*)::integer FROM small_buildings;

$$ LANGUAGE sql VOLATILE;
COMMENT ON FUNCTION buildings_bulk_load.bulk_load_outlines_remove_small_buildings(integer) IS
'Update bulk load status in bulk_load_outlines table of outlines less than 10sqm';

-------------------------------------------------------------------------
-- EXISTING SUBSET EXTRACT insert into
-- returns number of rows inserted into table
-------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.existing_subset_extracts_insert(
      p_building_outline_id integer
    , p_supplied_dataset_id integer
    , p_shape geometry
)
RETURNS integer AS
$$
    WITH insert_subset_extracts AS(
        INSERT INTO buildings_bulk_load.existing_subset_extracts(
              building_outline_id
            , supplied_dataset_id
            , shape
        )
        VALUES (
              p_building_outline_id
            , p_supplied_dataset_id
            , p_shape
        )
        RETURNING *
    )
    SELECT count(*)::integer FROM insert_subset_extracts

$$
LANGUAGE sql VOLATILE;

------------------------------------------------------------------------
-- EXISTING SUBSET EXTRACT update
-- update supplied dataset id of existing subset extracts outline
------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.existing_subset_extracts_update_supplied_dataset(
      p_supplied_dataset_id integer
    , p_building_outline_id integer
)
    RETURNS integer AS
$$
    WITH update_supplied_dataset AS (
        UPDATE buildings_bulk_load.existing_subset_extracts
        SET supplied_dataset_id = $1
        WHERE building_outline_id = $2
        RETURNING *
    )
    SELECT count(*)::integer FROM update_supplied_dataset;

$$ LANGUAGE sql VOLATILE;
COMMENT ON FUNCTION buildings_bulk_load.existing_subset_extracts_update_supplied_dataset(integer, integer) IS
'Update supplied_dataset_id in existing_subset_extracts table';


-------------------------------------------------------------------------
-- SUPPLIED DATASET insert into
-------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.supplied_datasets_insert(
      p_description varchar(250)
    , p_supplier_id integer
)
RETURNS integer AS
$$

    INSERT INTO buildings_bulk_load.supplied_datasets(
          supplied_dataset_id
        , description
        , supplier_id
        , processed_date
        , transfer_date
    )
    VALUES (
          DEFAULT -- sequence
        , p_description
        , p_supplier_id
        , NULL --processed_date
        , NULL --transfer_date
    )
    RETURNING supplied_dataset_id;

$$
LANGUAGE sql VOLATILE;

-------------------------------------------------------------------------
-- ORGANISATION insert into
-------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.organisation_insert(
      p_value varchar(250)
)
RETURNS integer AS
$$

    INSERT INTO buildings_bulk_load.organisation(
          organisation_id
        , value
    )
    VALUES (
          DEFAULT -- sequence
        , p_value

    )
    RETURNING organisation_id;

$$
LANGUAGE sql VOLATILE;

-------------------------------------------------------------------
--SUPPLIED DATASET select transfer_date
-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.supplied_datasets_select_transfer_date(integer)
    RETURNS timestamp AS
$$
    SELECT transfer_date
    FROM buildings_bulk_load.supplied_datasets
    WHERE buildings_bulk_load.supplied_datasets.supplied_dataset_id = $1

$$ LANGUAGE sql;

COMMENT ON FUNCTION buildings_bulk_load.supplied_datasets_select_transfer_date(integer) IS
'Return transfer_date in supplied_datasets table';

-------------------------------------------------------------------
--TRANSFERRED update
-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.transferred_insert(integer, integer)
    RETURNS integer AS
$$

    WITH transferred_insert AS (
        INSERT INTO buildings_bulk_load.transferred(bulk_load_outline_id, new_building_outline_id)
        VALUES($1, $2)
        RETURNING 1
    )
    SELECT count(*)::integer FROM transferred_insert;

$$ LANGUAGE sql VOLATILE;
COMMENT ON FUNCTION buildings_bulk_load.transferred_insert(integer, integer) IS
'Create new records in transferred table';

-------------------------------------------------------------------
--SUPPLIED DATASET update transfer_date
-------------------------------------------------------------------
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
COMMENT ON FUNCTION buildings_bulk_load.supplied_datasets_update_transfer_date(integer) IS
'Update transfer_date in supplied_datasets table';

-------------------------------------------------------------------
--SUPPLIED DATASET update processed_date
-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.supplied_datasets_update_processed_date(integer)
    RETURNS integer AS
$$
    WITH update_processed_date AS (
        UPDATE buildings_bulk_load.supplied_datasets
        SET processed_date = now()
        WHERE supplied_dataset_id = $1
        RETURNING *
    )
    SELECT count(*)::integer FROM update_processed_date;

$$ LANGUAGE sql;
COMMENT ON FUNCTION buildings_bulk_load.supplied_datasets_update_processed_date(integer) IS
'Update processed_date in supplied_datasets table';

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
          AND removed.qa_status_id != 5
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
          AND removed.qa_status_id != 5
    )

$$ LANGUAGE sql;
COMMENT ON FUNCTION buildings_bulk_load.buildings_removed_select_by_dataset(integer) IS
'Select building_id in removed table';

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
            AND supplied.bulk_load_status_id != 3
    );
$$ LANGUAGE sql;
COMMENT ON FUNCTION buildings_bulk_load.added_select_by_dataset(integer) IS
'Select bulk_load_outline_id in added table';

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
            AND supplied.bulk_load_status_id != 3
    );
$$ LANGUAGE sql;
COMMENT ON FUNCTION buildings_bulk_load.matched_select_by_dataset(integer) IS
'Select bulk_load_outline_id in matched table';

-------------------------------------------------------------------
--MATCHED select by dataset (BUILDING OUTLINES)
-------------------------------------------------------------------
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

-------------------------------------------------------------------
--RELATED select by dataset
-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.related_select_by_dataset(integer)
    RETURNS integer[] AS
$$
    SELECT ARRAY(
        SELECT DISTINCT bulk_load_outline_id
        FROM buildings_bulk_load.related
        JOIN buildings_bulk_load.bulk_load_outlines supplied USING (bulk_load_outline_id)
        WHERE supplied.supplied_dataset_id = $1
            AND supplied.bulk_load_status_id != 3
        ORDER BY bulk_load_outline_id DESC
    );

$$ LANGUAGE sql;
COMMENT ON FUNCTION buildings_bulk_load.related_select_by_dataset(integer) IS
'Select bulk_load_outline_id in related table';

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

-------------------------------------------------------------------
--BUILDING OUTLINES create new records
-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION buildings_bulk_load.building_outlines_insert_bulk(integer, integer)
    RETURNS integer AS
$$

    SELECT buildings.building_outlines_insert (
            $1
          , supplied.capture_method_id
          , supplied.capture_source_id
          , 1
          , supplied.suburb_locality_id
          , supplied.town_city_id
          , supplied.territorial_authority_id
          , supplied.begin_lifespan
          , supplied.shape
          )
        FROM buildings_bulk_load.bulk_load_outlines supplied
        WHERE supplied.bulk_load_outline_id = $2

$$ LANGUAGE sql;
COMMENT ON FUNCTION buildings_bulk_load.building_outlines_insert_bulk(integer, integer) IS
'Create new added records in building outlines table';

-------------------------------------------------------------------
--MATCHED return building_id
-------------------------------------------------------------------
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

-------------------------------------------------------------------------
-- ALTER_BUILDING_RELATIONSHIPS
-------------------------------------------------------------------------

-- Remove building outlines

CREATE OR REPLACE FUNCTION buildings_bulk_load.related_delete_existing_outlines(integer)
RETURNS integer AS
$$

    DELETE FROM buildings_bulk_load.related
    WHERE building_outline_id = $1
    RETURNING building_outline_id;

$$
LANGUAGE sql;

CREATE OR REPLACE FUNCTION buildings_bulk_load.matched_delete_existing_outlines(integer)
RETURNS integer AS
$$

    DELETE FROM buildings_bulk_load.matched
    WHERE building_outline_id = $1
    RETURNING building_outline_id;

$$
LANGUAGE sql;

CREATE OR REPLACE FUNCTION buildings_bulk_load.removed_delete_existing_outlines(integer)
RETURNS integer AS
$$

    DELETE FROM buildings_bulk_load.removed
    WHERE building_outline_id = $1
    RETURNING building_outline_id;

$$
LANGUAGE sql;

CREATE OR REPLACE FUNCTION buildings_bulk_load.added_delete_bulk_load_outlines(integer)
RETURNS integer AS
$$

    DELETE FROM buildings_bulk_load.added
    WHERE bulk_load_outline_id = $1
    RETURNING bulk_load_outline_id;

$$
LANGUAGE sql;

-- Insert building outlines

CREATE OR REPLACE FUNCTION buildings_bulk_load.added_insert_bulk_load_outlines(integer)
RETURNS integer AS
$$
    INSERT INTO buildings_bulk_load.added (bulk_load_outline_id, qa_status_id)
    VALUES ($1, 2)
    RETURNING added.bulk_load_outline_id;

$$
LANGUAGE sql;

CREATE OR REPLACE FUNCTION buildings_bulk_load.removed_insert_bulk_load_outlines(integer)
RETURNS integer AS
$$

    INSERT INTO buildings_bulk_load.removed (building_outline_id, qa_status_id)
    VALUES ($1, 2)
    RETURNING removed.building_outline_id;

$$
LANGUAGE sql;


CREATE OR REPLACE FUNCTION buildings_bulk_load.matched_insert_building_outlines(integer, integer)
RETURNS integer AS
$$

    INSERT INTO buildings_bulk_load.matched (bulk_load_outline_id, building_outline_id, qa_status_id)
    VALUES ($1, $2, 2)
    RETURNING matched.building_outline_id;

$$
LANGUAGE sql;


CREATE OR REPLACE FUNCTION buildings_bulk_load.related_group_insert()
RETURNS integer AS
$$

    INSERT INTO buildings_bulk_load.related_groups (related_group_id)
    VALUES (DEFAULT)
    RETURNING related_groups.related_group_id;

$$
LANGUAGE sql;


CREATE OR REPLACE FUNCTION buildings_bulk_load.related_insert_building_outlines(integer, integer, integer)
RETURNS integer AS
$$

    INSERT INTO buildings_bulk_load.related (related_group_id, bulk_load_outline_id, building_outline_id, qa_status_id)
    VALUES ($1, $2, $3, 2)
    RETURNING related.related_id;

$$
LANGUAGE sql;


-------------------------------------------------------------------------
-- DELETION_DESCRIPTION insert into
-------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION buildings_bulk_load.deletion_description_insert(integer, varchar(250))
RETURNS integer AS
$$

    INSERT INTO buildings_bulk_load.deletion_description (bulk_load_outline_id, description)
    VALUES ($1, $2)
    RETURNING deletion_description.bulk_load_outline_id;

$$
LANGUAGE sql;
