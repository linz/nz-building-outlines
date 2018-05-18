------------------------------------------------------------------------------
-- Populate buildings_lds schema in preparation for loading data to LDS
------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION buildings_lds.populate_buildings_lds()
RETURNS integer AS
$$

    WITH pop_buildings_lds AS(
        INSERT INTO buildings_lds.nz_building_outlines (
              building_outline_id
            , building_id
            , name
            , use
            , suburb_locality
            , town_city
            , territorial_authority
            , capture_method
            , capture_source
            , lifecycle_stage
            , outline_begin_lifespan
            , building_begin_lifespan
            , shape
        )
        SELECT
              building_outlines.building_outline_id
            , building_outlines.building_id
            , building_name.building_name
            , use.value
            , suburb_locality.suburb_4th
            , town_city.name
            , territorial_authority.name
            , capture_method.value
            , capture_source_group.value
            , lifecycle_stage.value
            , building_outlines.begin_lifespan
            , buildings.begin_lifespan
            , building_outlines.shape
        FROM buildings.building_outlines
        JOIN buildings.buildings USING (building_id)
        LEFT JOIN buildings.building_name USING (building_id)
        LEFT JOIN buildings.building_use USING (building_id)
        LEFT JOIN buildings.use USING (use_id)
        JOIN buildings.lifecycle_stage USING (lifecycle_stage_id)
        JOIN buildings_common.capture_method USING (capture_method_id)
        JOIN buildings_common.capture_source USING (capture_source_id)
        JOIN buildings_common.capture_source_group USING (capture_source_group_id)
        JOIN buildings_admin_bdys.suburb_locality ON suburb_locality.suburb_locality_id = building_outlines.suburb_locality_id
        JOIN buildings_admin_bdys.town_city ON town_city.town_city_id = building_outlines.town_city_id
        JOIN buildings_admin_bdys.territorial_authority ON territorial_authority.territorial_authority_id = building_outlines.territorial_authority_id
        WHERE building_outlines.end_lifespan IS NULL
        AND buildings.end_lifespan IS NULL
        AND building_name.end_lifespan IS NULL
        AND building_use.end_lifespan IS NULL
        ORDER BY building_outlines.building_outline_id
        RETURNING *
    )
    SELECT count(*)::integer FROM pop_buildings_lds;

$$
LANGUAGE sql VOLATILE;
