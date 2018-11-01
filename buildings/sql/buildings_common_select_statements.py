"""
----------------------------------------------------------------
Buildings Common
----------------------------------------------------------------
"""

# capture method

capture_method_value = """
SELECT value
FROM buildings_common.capture_method;
"""

capture_method_value_by_dataset_id = """
SELECT value
FROM buildings_common.capture_method cm,
     buildings_bulk_load.bulk_load_outlines blo
WHERE blo.capture_method_id = cm.capture_method_id
AND blo.supplied_dataset_id = %s;
"""

capture_method_id_by_value = """
SELECT capture_method_id
FROM buildings_common.capture_method cm
WHERE cm.value = %s;
"""

capture_method_value_by_bulk_outline_id = """
SELECT value
FROM buildings_common.capture_method cm,
     buildings_bulk_load.bulk_load_outlines blo
WHERE blo.capture_method_id = cm.capture_method_id
AND blo.bulk_load_outline_id = %s;
"""

capture_method_value_by_building_outline_id = """
SELECT value
FROM buildings_common.capture_method cm,
     buildings.building_outlines bo
WHERE bo.capture_method_id = cm.capture_method_id
AND bo.building_outline_id = %s;
"""

capture_method_by_value = """
SELECT *
FROM buildings_common.capture_method
WHERE buildings_common.capture_method.value = %s;
"""

# capture source group

capture_source_group_value_description = """
SELECT value, description
FROM buildings_common.capture_source_group;
"""

capture_source_group_by_value = """
SELECT *
FROM buildings_common.capture_source_group
WHERE buildings_common.capture_source_group.value = %s;
"""

capture_source_group_id_by_dataset_id = """
SELECT cs.capture_source_group_id
FROM buildings_common.capture_source_group csg,
     buildings_common.capture_source cs,
     buildings_bulk_load.bulk_load_outlines blo
WHERE blo.supplied_dataset_id = %s
AND blo.capture_source_id = cs.capture_source_id
AND cs.capture_source_group_id = csg.capture_source_group_id;
"""

capture_source_group_id_by_value = """
SELECT capture_source_group_id
FROM buildings_common.capture_source_group
WHERE value = %s;
"""

capture_source_group_by_value_and_description = """
SELECT capture_source_group_id
FROM buildings_common.capture_source_group csg
WHERE csg.value = %s
AND csg.description = %s;
"""

capture_source_group_value_description_external = """
SELECT csg.value,
       csg.description,
       cs.external_source_id
FROM buildings_common.capture_source_group csg,
     buildings_common.capture_source cs
WHERE cs.capture_source_group_id = csg.capture_source_group_id;
"""

capture_source_group_value_description_external_by_bulk_outline_id = """
SELECT csg.value,
       csg.description,
       cs.external_source_id
FROM buildings_common.capture_source_group csg,
     buildings_common.capture_source cs,
     buildings_bulk_load.bulk_load_outlines blo
WHERE csg.capture_source_group_id = cs.capture_source_group_id
AND blo.capture_source_id = cs.capture_source_id
AND blo.bulk_load_outline_id = %s;
"""

capture_source_group_value_description_external_by_building_outline_id = """
SELECT csg.value,
       csg.description,
       cs.external_source_id
FROM buildings_common.capture_source_group csg,
     buildings_common.capture_source cs,
     buildings.building_outlines bo
WHERE csg.capture_source_group_id = cs.capture_source_group_id
AND bo.capture_source_id = cs.capture_source_id
AND bo.building_outline_id = %s;
"""

# capture source

capture_source_external_source_id_by_dataset_id = """
SELECT cs.external_source_id
FROM buildings_common.capture_source cs,
     buildings_bulk_load.bulk_load_outlines blo
WHERE blo.supplied_dataset_id = %s
AND blo.capture_source_id = cs.capture_source_id;
"""

capture_source_external_source_id = """
SELECT external_source_id
FROM buildings_common.capture_source;
"""

capture_source_id_by_capture_source_group_id_and_external_source_id = """
SELECT capture_source_id
FROM buildings_common.capture_source cs
WHERE cs.capture_source_group_id = %s
AND cs.external_source_id = %s;
"""

capture_source_id_by_capture_source_group_id_is_null = """
SELECT cs.capture_source_id
FROM buildings_common.capture_source cs
WHERE cs.capture_source_group_id = %s
AND cs.external_source_id is NULL;
"""

capture_source_value_description = """
SELECT value,
       description
FROM buildings_common.capture_source_group;
"""

capture_source_by_group_id = """
SELECT external_source_id
FROM buildings_common.capture_source
WHERE buildings_common.capture_source.capture_source_group_id = %s;
"""

capture_source_area_name_by_supplied_dataset = """
SELECT csa.area_title
FROM buildings_bulk_load.bulk_load_outlines blo
JOIN buildings_common.capture_source cs USING (capture_source_id)
JOIN buildings_reference.capture_source_area csa ON CAST( csa.external_area_polygon_id as varchar(250) ) = cs.external_source_id
WHERE supplied_dataset_id = %s;
"""
