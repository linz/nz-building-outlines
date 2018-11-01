"""
--------------------------------------------------------------------
buildings reference
--------------------------------------------------------------------
"""

# suburb locality

suburb_locality_suburb_4th = """
SELECT DISTINCT suburb_4th
FROM buildings_reference.suburb_locality;
"""

suburb_locality_suburb_4th_by_bulk_outline_id = """
SELECT suburb_4th
FROM buildings_reference.suburb_locality sl,
     buildings_bulk_load.bulk_load_outlines blo
WHERE sl.suburb_locality_id = blo.suburb_locality_id
AND blo.bulk_load_outline_id = %s;
"""

suburb_locality_suburb_4th_by_building_outline_id = """
SELECT suburb_4th
FROM buildings_reference.suburb_locality sl,
     buildings.building_outlines bo
WHERE sl.suburb_locality_id = bo.suburb_locality_id
AND bo.building_outline_id = %s;
"""

suburb_locality_intersect_geom = """
SELECT suburb_locality_id, suburb_4th
FROM buildings_reference.suburb_locality
WHERE shape && ST_Expand(%s::Geometry, 1000)
ORDER BY suburb_4th;
"""

# town city

town_city_name = """
SELECT DISTINCT name
FROM buildings_reference.town_city;
"""

town_city_name_by_bulk_outline_id = """
SELECT name
FROM buildings_reference.town_city tc,
     buildings_bulk_load.bulk_load_outlines blo
WHERE tc.town_city_id = blo.town_city_id
AND blo.bulk_load_outline_id = %s;
"""

town_city_name_by_building_outline_id = """
SELECT name
FROM buildings_reference.town_city tc,
     buildings.building_outlines bo
WHERE tc.town_city_id = bo.town_city_id
AND bo.building_outline_id = %s;
"""

town_city_intersect_geometry = """
SELECT town_city_id, name
FROM buildings_reference.town_city
WHERE ST_Intersects(shape, ST_Buffer(%s::Geometry, 1000))
ORDER BY name
"""

# territorial Authority

territorial_authority_name = """
SELECT DISTINCT name
FROM buildings_reference.territorial_authority;
"""

territorial_authority_name_by_bulk_outline_id = """
SELECT name
FROM buildings_reference.territorial_authority ta,
     buildings_bulk_load.bulk_load_outlines blo
WHERE ta.territorial_authority_id = blo.territorial_authority_id
AND blo.bulk_load_outline_id = %s;
"""

territorial_authority_name_by_building_outline_id = """
SELECT name
FROM buildings_reference.territorial_authority ta,
     buildings.building_outlines bo
WHERE ta.territorial_authority_id = bo.territorial_authority_id
AND bo.building_outline_id = %s;
"""

territorial_authority_intersect_geom = """
SELECT territorial_authority_id, name
FROM buildings_reference.territorial_authority
WHERE shape && ST_Expand(%s::Geometry, 1000)
ORDER BY name;
"""

# Capture Source Area

capture_source_area_id_and_name = """
SELECT csa.external_area_polygon_id, csa.area_title
FROM buildings_reference.capture_source_area csa
ORDER BY csa.area_title;
"""

capture_source_area_shape_by_title = """
SELECT shape
FROM buildings_reference.capture_source_area
WHERE area_title = %s;
"""
