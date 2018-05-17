CREATE OR REPLACE FUNCTION buildings_bulk_load.create_building_relationship_view()
    RETURNS void
AS $$

    CREATE OR REPLACE VIEW buildings_bulk_load.added_outlines AS
        SELECT a.bulk_load_outline_id, b.shape
        FROM buildings_bulk_load.added a
        JOIN buildings_bulk_load.bulk_load_outlines b USING (bulk_load_outline_id);

    CREATE OR REPLACE VIEW buildings_bulk_load.removed_outlines AS
        SELECT r.building_outline_id, e.shape
        FROM buildings_bulk_load.removed r
        JOIN buildings_bulk_load.existing_subset_extracts e USING (building_outline_id);

    CREATE OR REPLACE VIEW buildings_bulk_load.matched_bulk_load_outlines AS
        SELECT m.bulk_load_outline_id, b.shape
        FROM buildings_bulk_load.matched m
        JOIN buildings_bulk_load.bulk_load_outlines b USING (bulk_load_outline_id);

    CREATE OR REPLACE VIEW buildings_bulk_load.related_bulk_load_outlines AS
        SELECT DISTINCT r.bulk_load_outline_id, b.shape
        FROM buildings_bulk_load.related r
        JOIN buildings_bulk_load.bulk_load_outlines b USING (bulk_load_outline_id);

    CREATE OR REPLACE VIEW buildings_bulk_load.matched_existing_outlines AS
        SELECT m.building_outline_id, e.shape
        FROM buildings_bulk_load.matched m
        JOIN buildings_bulk_load.existing_subset_extracts e USING (building_outline_id);

    CREATE OR REPLACE VIEW buildings_bulk_load.related_existing_outlines AS
        SELECT DISTINCT r.building_outline_id, e.shape
        FROM buildings_bulk_load.related r
        JOIN buildings_bulk_load.existing_subset_extracts e USING (building_outline_id);

$$ LANGUAGE sql;
