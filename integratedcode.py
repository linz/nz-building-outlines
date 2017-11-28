# integrated code

#  relevant inputs
from qgis.utils import iface
from PyQt4.QtGui import *
from PyQt4.QtCore import *
import processing
import csv


#############################################################################


def read_in_files(existing, incoming):
    # function to read in the existing and input files
    existingLayer = iface.addVectorLayer(existing, "1-", "ogr")
    if not existingLayer:
        print "existing layer not found"
    incomingLayer = iface.addVectorLayer(incoming, "2-", "ogr")
    if not incomingLayer:
        print "incoming layer not found"
    return [existingLayer, incomingLayer]

##############################################################################


def removed_buildings(existing, incoming):
    # Finding removed buildings
    existing.selectAll()
    # selecting the buildings
    processing.runalg("qgis:selectbylocation", existing, incoming,
                      ['intersects'], 0, 2)
    # save selection to file
    name = 'Removed Buildings'  # name of shapefile

    processing.runalg('qgis:saveselectedfeatures', existing, path)
    # reading shapefile back into qgis
    removed = iface.addVectorLayer(path + name + '.shp', "Output 1-", "ogr")
    return removed

##############################################################################


def new_buildings(existing, incoming):
    # Finding new buildings
    incoming.selectAll()
    # selecting the buildings
    processing.runalg("qgis:selectbylocation", incoming, existing,
                      ['intersects'], 0, 2)
    # save selection to file
    name = 'New Buildings'  # name of shapefile

    processing.runalg('qgis:saveselectedfeatures', incoming, path)
    # reading shapefile back into qgis
    new = iface.addVectorLayer(path + name + '.shp', "Output 2-", "ogr")
    return new

#############################################################################


def potential_match(existing, incoming):
    # Finding potential Match in existing buildings
    processing.runalg("qgis:selectbylocation", existing, incoming,
                      ['intersects'], 0, 0)  # selecting the buildings
    # save selection to file
    name_e = 'Potential Match Existing Layer'  # name of shapefile

    processing.runalg('qgis:saveselectedfeatures',
                      existing, path + name_e + '.shp')
    # reading shapefile back into qgis
    PM_existing = iface.addVectorLayer(path + name_e + '.shp',
                                       "Output 3-", "ogr")
    # existing.removeSelection()
    incoming.removeSelection()
    # Finding potential Match in incominging buildings
    processing.runalg("qgis:selectbylocation", incoming, existing,
                      ['intersects'], 0, 0)  # selecting the buildings

    # save selection to file
    name = 'Potential Match IncomingLayer'  # name of shapefile
    processing.runalg('qgis:saveselectedfeatures',
                      incoming, path + name + '.shp')
    # reading shapefile back into qgis
    PM_incoming = iface.addVectorLayer(path + name + '.shp',
                                       "Output 4-", "ogr")

    return[PM_existing, PM_incoming]

###############################################################################


def add_building_id(Potential_existing, Potential_incoming):
    # Adding Building id Field for Existing Potential Matches
    provider = Potential_existing.dataProvider()
    Build_id = [feat.id() for feat in Potential_existing.getFeatures()]
    field = QgsField("Build_id", QVariant.Double)
    provider.addAttributes([field])
    Potential_existing.updateFields()
    idx = Potential_existing.fieldNameIndex('Build_id')
    for bid in Build_id:
        new_values = {idx: bid}
        provider.changeAttributeValues({Build_id.index(bid): new_values})

    # Adding empty Building id field for Incoming Potential Matches
    providerI = Potential_incoming.dataProvider()
    fieldI = QgsField("Build_id", QVariant.Double)
    providerI.addAttributes([fieldI])
    Potential_incoming.updateFields()

#############################################################################


def finding_intersecting_buildings(potential_exisitng, potential_incoming):
    values = {}

    for building in potential_incoming.getFeatures():
        build = building.geometry()
        for polygon in potential_exisitng.getFeatures():
            poly = polygon.geometry()
            if poly.intersects(build):
                if building.id() in values:
                    values[building.id()].append(polygon.id())
                else:
                    temp = [polygon.id()]
                    values[building.id()] = temp

    max_intersect = -99999
    for key in values:
        temp = len(values[key])
        if temp > max_intersect:
            max_intersect = temp

    count = 1
    idx = []
    provider_intersect = potential_incoming.dataProvider()
    while count <= max_intersect:
        field_intersect = "e_Bid" + str(count)
        fieldI = QgsField(field_intersect, QVariant.Double)
        provider_intersect.addAttributes([fieldI])
        potential_match_incoming.updateFields()
        temp = potential_match_incoming.fieldNameIndex(field_intersect)
        idx.append(temp)
        count = count + 1
    count = 0
    while count < max_intersect:
        idx_value = idx[count]
        b = 0
        for building_id in values:
            b = b + 1
            temp_v = values[building_id]
            if len(temp_v) > count:
                new_values = {idx_value: temp_v[count]}
                provider_intersect.changeAttributeValues({building_id:
                                                         new_values})
        count = count + 1

##############################################################


def calculate_area(potential_existing, potential_incoming):
    # Adding Area Field for Existing Potential Matches
    provider = potential_existing.dataProvider()
    areas = [feat.geometry().area() for feat in
             potential_existing.getFeatures()]
    field = QgsField("area", QVariant.Double)
    provider.addAttributes([field])
    potential_existing.updateFields()
    idx = potential_existing.fieldNameIndex('area')
    for area in areas:
        new_values = {idx: float(area)}
        provider.changeAttributeValues({areas.index(area): new_values})

    # Adding Area Field for Existing Potential Matches
    provider = potential_incoming.dataProvider()
    areas = [feat.geometry().area() for feat in
             potential_incoming.getFeatures()]
    field = QgsField("area", QVariant.Double)
    provider.addAttributes([field])
    potential_incoming.updateFields()
    idx = potential_incoming.fieldNameIndex('area')
    for area in areas:
        new_values = {idx: float(area)}
        provider.changeAttributeValues({areas.index(area): new_values})


###########################################################


def calculate_overlap(potential_existing, potential_incoming):
    # Calculate Symmetrical Difference
    name = 'Symmetric Difference'  # name of shapefile

    processing.runalg('qgis:symmetricaldifference', potential_existing,
                      potential_incoming, path)
    # reading shapefile back into qgis
    SDiff = iface.addVectorLayer(path + name + '.shp', "Output 5-",
                                 "ogr")

    # Split Symmetric Difference Layer by existing field
    processing.runalg('qgis:selectbyattribute', SDiff, 'id',
                      0, "id is not NULL")
    name = "sdiff_existing"
    processing.runalg('qgis:saveselectedfeatures', SDiff, path + name)
    SDiff_existing = iface.addVectorLayer(path + name + '.shp',
                                          "temp 1-", "ogr")

    # Adding Area Field for Existing Potential Matches
    provider = SDiff_existing.dataProvider()
    areas = []
    for feat in SDiff_existing.getFeatures():
        if feat.geometry() is None:
            areas.append(float(0))

        else:
            areas.append(feat.geometry().area())

    # Adding area field to existing symmetrical difference layer
    provider = SDiff_existing.dataProvider()
    field1 = QgsField("areaDiff", QVariant.Double)
    provider.addAttributes([field1])
    SDiff_existing.updateFields()
    idx = SDiff_existing.fieldNameIndex('areaDiff')
    for area in areas:
        new_values = {idx: float(area)}
        provider.changeAttributeValues({areas.index(area): new_values})

    # joing the existing symmetric difference area to the existing
    # potential match attributes table
    match_layer = potential_existing
    diff_table = SDiff_existing
    MATCH_ID = 'id'
    DIFF_ID = 'id'
    joinObject = QgsVectorJoinInfo()
    joinObject.joinLayerId = diff_table.id()
    joinObject.joinFieldName = DIFF_ID
    joinObject.targetFieldName = MATCH_ID
    joinObject.memoryCache = True
    # specifying to only copy the areaDiff field
    joinObject.setJoinFieldNamesSubset(['areaDiff'])
    match_layer.addJoin(joinObject)

    # Creating new Field Overlap
    # existing
    provider = potential_existing.dataProvider()
    field = QgsField("Overlap", QVariant.Double)
    provider.addAttributes([field])
    potential_existing.updateFields()
    idx = potential_existing.fieldNameIndex('Overlap')

    # caclulating overlap existing
    provider = SDiff_existing.dataProvider()
    potential_existing.startEditing()
    expression = QgsExpression('100-(("temp 1- sdiff_existing Polygon_areaDiff"/"area")*100)')
    # print expression
    expression.prepare(potential_existing.pendingFields())

    for f in potential_existing.getFeatures():
        f[idx] = expression.evaluate(f)
        potential_existing.updateFeature(f)

    potential_existing.commitChanges()

    # Split Symmetric Difference Layer by incoming field
    processing.runalg('qgis:selectbyattribute', SDiff, 'id_2',
                      0, "id_2 is not NULL")
    name = "sdiff_incoming"
    processing.runalg('qgis:saveselectedfeatures', SDiff, path + name)
    SDiff_incoming = iface.addVectorLayer(path + name + '.shp',
                                          "temp 2-", "ogr")

    # Adding Area Field for Incoming Potential Matches
    provider = SDiff_incoming.dataProvider()
    areas = []
    for feat in SDiff_incoming.getFeatures():
        if feat.geometry() is None:
            areas.append(float(0))

        else:
            areas.append(feat.geometry().area())

    # Adding area field to incoming symmetrical difference layer
    provider = SDiff_incoming.dataProvider()
    field1 = QgsField("areaDiff", QVariant.Double)
    provider.addAttributes([field1])
    SDiff_incoming.updateFields()
    idx = SDiff_incoming.fieldNameIndex('areaDiff')
    for area in areas:
        new_values = {idx: float(area)}
        provider.changeAttributeValues({areas.index(area): new_values})

    # joing the incoming symmetric difference area to
    # the incoming potential match attributes
    # table
    match_layer = potential_incoming
    diff_table = SDiff_incoming
    MATCH_ID = 'id'
    DIFF_ID = 'id_2'
    joinObject = QgsVectorJoinInfo()
    joinObject.joinLayerId = diff_table.id()
    joinObject.joinFieldName = DIFF_ID
    joinObject.targetFieldName = MATCH_ID
    joinObject.memoryCache = True
    # specifying to only copy the areaDiff field
    joinObject.setJoinFieldNamesSubset(['areaDiff'])
    match_layer.addJoin(joinObject)

    # Incoming
    provider = potential_incoming.dataProvider()
    field = QgsField("Overlap", QVariant.Double)
    provider.addAttributes([field])
    potential_incoming.updateFields()
    idx = potential_incoming.fieldNameIndex('Overlap')
    # print idx # debugging

    # caclulating overlap incoming
    provider = SDiff_incoming.dataProvider()
    potential_incoming.startEditing()
    expression = QgsExpression('100-(("temp 2- sdiff_incoming Polygon_areaDiff"/"area")*100)')
    # print expression
    expression.prepare(potential_incoming.pendingFields())

    for f in potential_incoming.getFeatures():
        f[idx] = expression.evaluate(f)
        potential_incoming.updateFeature(f)

    potential_incoming.commitChanges()


#####################################################################
# Main Code:

# USER EDITS HERE:
input_existing_text = '/home/linz_user/data/BuildingsProcessing/finalDataQGIS/existing_building_outlines_subset.shp'
input_incoming_text = '/home/linz_user/data/BuildingsProcessing/finalDataQGIS/incoming_building_outlines_subset.shp'
path = "/home/linz_user/data/BuildingsProcessing/FinalDataPyQGIS/"
# csv file name
# threshold value
# max existing building intersections


# call read in function
layers = read_in_files(input_existing_text, input_incoming_text)
existing_layer = layers[0]
incoming_layer = layers[1]

# find removed buildings
removed = removed_buildings(existing_layer, incoming_layer)

existing_layer.removeSelection()
incoming_layer.removeSelection()

# find new buildings
new = new_buildings(existing_layer, incoming_layer)

existing_layer.removeSelection()
incoming_layer.removeSelection()

# find potential matches
potential_matches = potential_match(existing_layer, incoming_layer)
potential_match_existing = potential_matches[0]
potential_match_incoming = potential_matches[1]

# add/prepare building IDs
add_building_id(potential_match_existing, potential_match_incoming)

# Find the existing building ids of the incoming intersecting buildings
# this adds new fields to the attribute tables of the incoming layer
finding_intersecting_buildings(potential_match_existing, potential_match_incoming)

# calculates the area of each polygon and adds it to area fields in the
# potential match attributes tables
calculate_area(potential_match_existing, potential_match_incoming)

calculate_overlap(potential_match_existing, potential_match_incoming)

# generate_csv(potential_match_existing, potential_match_incoming)

# final_output()