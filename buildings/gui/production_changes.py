from builtins import next
from builtins import object
# -*- coding: utf-8 -*-\
from collections import OrderedDict

from qgis.PyQt.QtCore import pyqtSlot
from qgis.PyQt.QtWidgets import QToolButton, QMessageBox
from qgis.core import QgsFeatureRequest, QgsGeometry
from qgis.gui import QgsMessageBar
from qgis.utils import iface

from buildings.gui.error_dialog import ErrorDialog
from buildings.sql import (
    buildings_bulk_load_select_statements as bulk_load_select,
    buildings_common_select_statements as common_select,
    buildings_select_statements as buildings_select,
    buildings_reference_select_statements as reference_select,
    general_select_statements as general_select,
)


class ProductionChanges(object):
    """
        Parent class of Production changes (editing and adding outlines)
    """

    def __init__(self, edit_dialog):
        """Constructor."""
        # setup
        self.edit_dialog = edit_dialog
        self.parent_frame = self.edit_dialog.parent_frame
        self.editing_layer = self.edit_dialog.editing_layer
        iface.setActiveLayer(self.editing_layer)

    def confirmation_dialog_box(self, button_text):
        return QMessageBox(
            QMessageBox.Question,
            button_text.upper(),
            "Are you sure you want to remove outlines? \n This action cannot be reversed.",
            buttons=QMessageBox.No | QMessageBox.Yes,
        )

    def confirm(self, msgbox):
        reply = msgbox.exec_()
        if reply == QMessageBox.Yes:
            return True
        return False

    def populate_edit_comboboxes(self):
        """
            Populate editing combox fields
        """
        if self.edit_dialog.layout_capture_method.isVisible():
            # populate capture method combobox
            result = self.edit_dialog.db._execute(common_select.capture_method_value)
            ls = result.fetchall()
            for item in ls:
                self.edit_dialog.cmb_capture_method.addItem(item[0])

        if self.edit_dialog.layout_general_info.isVisible():
            # populate capture source group
            result = self.edit_dialog.db._execute(
                common_select.capture_source_group_value_external
            )
            ls = result.fetchall()
            text_max = ""
            for item in ls:
                text = "- ".join(item)
                self.edit_dialog.cmb_capture_source.addItem(text)
                if len(text) > len(text_max):
                    text_max = text
            self.fix_truncated_dropdown(self.edit_dialog.cmb_capture_source, text_max)

            # populate lifecycle stage combobox
            result = self.edit_dialog.db._execute(
                buildings_select.lifecycle_stage_value
            )
            ls = result.fetchall()
            for item in ls:
                self.edit_dialog.cmb_lifecycle_stage.addItem(item[0])

            # populate territorial authority combobox
            result = self.edit_dialog.db._execute(
                reference_select.territorial_authority_intersect_geom,
                (self.edit_dialog.geom,),
            )
            self.edit_dialog.ids_ta = []
            for (id_ta, name) in result.fetchall():
                self.edit_dialog.cmb_ta.addItem(name)
                self.edit_dialog.ids_ta.append(id_ta)

            # populate suburb combobox
            result = self.edit_dialog.db._execute(
                reference_select.suburb_locality_intersect_geom,
                (self.edit_dialog.geom,),
            )
            self.edit_dialog.ids_suburb = []
            for (id_suburb, name) in result.fetchall():
                if name is not None:
                    self.edit_dialog.cmb_suburb.addItem(name)
                    self.edit_dialog.ids_suburb.append(id_suburb)

            # populate town combobox
            result = self.edit_dialog.db._execute(
                reference_select.town_city_intersect_geometry, (self.edit_dialog.geom,)
            )
            self.edit_dialog.cmb_town.addItem("")
            self.edit_dialog.ids_town = [None]
            for (id_town, name) in result.fetchall():
                if name is not None:
                    self.edit_dialog.cmb_town.addItem(name)
                    self.edit_dialog.ids_town.append(id_town)

    def get_comboboxes_values(self):
        if self.edit_dialog.layout_capture_method.isVisible():
            # capture method id
            text = self.edit_dialog.cmb_capture_method.currentText()
            result = self.edit_dialog.db.execute_no_commit(
                common_select.capture_method_id_by_value, (text,)
            )
            capture_method_id = result.fetchall()[0][0]
        else:
            capture_method_id = None

        if self.edit_dialog.layout_general_info.isVisible():
            # capture source
            text = self.edit_dialog.cmb_capture_source.currentText()
            text_ls = text.split("- ")
            result = self.edit_dialog.db.execute_no_commit(
                common_select.capture_source_group_id_by_value, (text_ls[2],)
            )
            data = result.fetchall()[0][0]
            if text_ls[0] == "None":
                result = self.edit_dialog.db.execute_no_commit(
                    common_select.capture_source_id_by_capture_source_group_id_is_null,
                    (data,),
                )
            else:
                result = self.edit_dialog.db.execute_no_commit(
                    common_select.capture_source_id_by_capture_source_group_id_and_external_source_id,
                    (data, text_ls[0]),
                )
            capture_source_id = result.fetchall()[0][0]

            # lifecycle stage
            text = self.edit_dialog.cmb_lifecycle_stage.currentText()
            result = self.edit_dialog.db.execute_no_commit(
                buildings_select.lifecycle_stage_id_by_value, (text,)
            )
            lifecycle_stage_id = result.fetchall()[0][0]

            # suburb
            index = self.edit_dialog.cmb_suburb.currentIndex()
            suburb = self.edit_dialog.ids_suburb[index]

            # town
            index = self.edit_dialog.cmb_town.currentIndex()
            town = self.edit_dialog.ids_town[index]

            # territorial Authority
            index = self.edit_dialog.cmb_ta.currentIndex()
            t_a = self.edit_dialog.ids_ta[index]
        else:
            capture_source_id, lifecycle_stage_id, suburb, town, t_a = (
                None,
                None,
                None,
                None,
                None,
            )
        return (
            capture_method_id,
            capture_source_id,
            lifecycle_stage_id,
            suburb,
            town,
            t_a,
        )

    def enable_UI_functions(self):
        """
            Function called when comboboxes are to be enabled
        """
        self.edit_dialog.cmb_capture_method.clear()
        self.edit_dialog.cmb_capture_method.setEnabled(1)
        self.edit_dialog.cmb_capture_source.clear()
        self.edit_dialog.cmb_capture_source.setEnabled(1)
        self.edit_dialog.cmb_lifecycle_stage.clear()
        self.edit_dialog.cmb_lifecycle_stage.setEnabled(1)
        self.edit_dialog.cmb_ta.clear()
        self.edit_dialog.cmb_ta.setEnabled(1)
        self.edit_dialog.cmb_town.clear()
        self.edit_dialog.cmb_town.setEnabled(1)
        self.edit_dialog.cmb_suburb.clear()
        self.edit_dialog.cmb_suburb.setEnabled(1)
        self.edit_dialog.btn_edit_save.setEnabled(1)
        self.edit_dialog.btn_edit_reset.setEnabled(1)
        self.edit_dialog.btn_end_lifespan.setEnabled(1)

    def disable_UI_functions(self):
        """
            Function called when comboboxes are to be disabled
        """
        self.edit_dialog.cmb_capture_method.clear()
        self.edit_dialog.cmb_capture_method.setDisabled(1)
        self.edit_dialog.cmb_capture_source.clear()
        self.edit_dialog.cmb_capture_source.setDisabled(1)
        self.edit_dialog.cmb_lifecycle_stage.clear()
        self.edit_dialog.cmb_lifecycle_stage.setDisabled(1)
        self.edit_dialog.cmb_ta.clear()
        self.edit_dialog.cmb_ta.setDisabled(1)
        self.edit_dialog.cmb_town.clear()
        self.edit_dialog.cmb_town.setDisabled(1)
        self.edit_dialog.cmb_suburb.clear()
        self.edit_dialog.cmb_suburb.setDisabled(1)
        self.edit_dialog.btn_edit_save.setDisabled(1)
        self.edit_dialog.btn_edit_reset.setDisabled(1)
        self.edit_dialog.btn_end_lifespan.setDisabled(1)

    def fix_truncated_dropdown(self, cmb, text):
        """
            Fix the trucated cmb dropdown in windows
        """
        w = cmb.fontMetrics().boundingRect(text).width()
        cmb.view().setFixedWidth(w + 30)


class AddProduction(ProductionChanges):
    """
        Class to add outlines to buildings.building_outlines
        Inherits ProductionChanges
    """

    def __init__(self, edit_dialog):
        """Constructor"""
        ProductionChanges.__init__(self, edit_dialog)
        iface.actionToggleEditing().trigger()
        # set editing to add polygon
        iface.actionAddFeature().trigger()
        # setup toolbar
        selecttools = iface.attributesToolBar().findChildren(QToolButton)
        # selection actions
        iface.building_toolbar.addSeparator()
        for sel in selecttools:
            if sel.text() == "Select Feature(s)":
                for a in sel.actions()[0:3]:
                    iface.building_toolbar.addAction(a)
        # editing actions
        iface.building_toolbar.addSeparator()
        for dig in iface.digitizeToolBar().actions():
            if dig.objectName() in [
                "mActionAddFeature",
                "mActionNodeTool",
                "mActionMoveFeature",
            ]:
                iface.building_toolbar.addAction(dig)
        # advanced Actions
        iface.building_toolbar.addSeparator()
        for adv in iface.advancedDigitizeToolBar().actions():
            if adv.objectName() in [
                "mActionUndo",
                "mActionRedo",
                "mActionReshapeFeatures",
                "mActionOffsetCurve",
            ]:
                iface.building_toolbar.addAction(adv)
        iface.building_toolbar.show()
        self.disable_UI_functions()

    @pyqtSlot(bool)
    def edit_save_clicked(self, commit_status):
        """
            When building frame btn_edit_save clicked
        """
        self.edit_dialog.db.open_cursor()

        capture_method_id, capture_source_id, lifecycle_stage_id, suburb, town, t_a = (
            self.get_comboboxes_values()
        )

        # insert into buildings
        sql = "SELECT buildings.buildings_insert();"
        result = self.edit_dialog.db.execute_no_commit(sql)
        building_id = result.fetchall()[0][0]
        # insert into building_outlines table
        sql = (
            "SELECT buildings.building_outlines_insert(%s, %s, %s, %s, %s, %s, %s, %s);"
        )
        result = self.edit_dialog.db.execute_no_commit(
            sql,
            (
                building_id,
                capture_method_id,
                capture_source_id,
                lifecycle_stage_id,
                suburb,
                town,
                t_a,
                self.edit_dialog.geom,
            ),
        )
        self.edit_dialog.outline_id = result.fetchall()[0][0]

        if commit_status:
            self.edit_dialog.db.commit_open_cursor()
            self.edit_dialog.geom = None
            self.edit_dialog.added_geoms = OrderedDict()
        # reset and disable comboboxes
        self.disable_UI_functions()

    @pyqtSlot()
    def edit_reset_clicked(self):
        """
            When production frame btn_edit_reset clicked
        """
        self.editing_layer.geometryChanged.disconnect(self.creator_geometry_changed)
        iface.actionCancelEdits().trigger()
        self.editing_layer.geometryChanged.connect(self.creator_geometry_changed)
        # restart editing
        iface.actionToggleEditing().trigger()
        iface.actionAddFeature().trigger()
        # reset and disable comboboxes
        if self.parent_frame.polyline:
            self.parent_frame.polyline.reset()
        iface.mapCanvas().refresh()
        self.disable_UI_functions()

        self.edit_dialog.geom = None
        self.edit_dialog.added_geoms = OrderedDict()

    @pyqtSlot(int)
    def creator_feature_added(self, qgsfId):
        """
           Called when feature is added
           @param qgsfId:      Id of added feature
           @type  qgsfId:      qgis.core.QgsFeature.QgsFeatureId
        """
        if self.edit_dialog.added_geoms != {}:
            iface.messageBar().pushMessage(
                "WARNING",
                "You've drawn multiple outlines, only the LAST outline you've drawn will be saved.",
                level=QgsMessageBar.WARNING,
                duration=3,
            )
        # get new feature geom
        request = QgsFeatureRequest().setFilterFid(qgsfId)
        new_feature = next(self.editing_layer.getFeatures(request))
        new_geometry = new_feature.geometry()
        # calculate area
        area = new_geometry.area()
        if area < 10:
            iface.messageBar().pushMessage(
                "INFO",
                "You've drawn an outline that is less than 10sqm, are you sure this is correct?",
                level=QgsMessageBar.INFO,
                duration=3,
            )
        # convert to correct format
        wkt = new_geometry.exportToWkt()
        sql = general_select.convert_geometry
        result = self.edit_dialog.db._execute(sql, (wkt,))
        geom = result.fetchall()[0][0]

        if qgsfId not in list(self.edit_dialog.added_geoms.keys()):
            self.edit_dialog.added_geoms[qgsfId] = geom
            self.edit_dialog.geom = geom

        # enable & populate comboboxes
        self.enable_UI_functions()
        self.populate_edit_comboboxes()
        self.select_comboboxes_value()

        self.edit_dialog.activateWindow()
        self.edit_dialog.btn_edit_save.setDefault(True)

    @pyqtSlot(int)
    def creator_feature_deleted(self, qgsfId):
        """
            Called when a Feature is Deleted
            @param qgsfId:      Id of deleted feature
            @type  qgsfId:      qgis.core.QgsFeature.QgsFeatureId
        """
        if qgsfId in list(self.edit_dialog.added_geoms.keys()):
            del self.edit_dialog.added_geoms[qgsfId]
            if self.parent_frame.polyline is not None:
                self.parent_frame.polyline.reset()
            if self.edit_dialog.added_geoms == {}:
                self.disable_UI_functions()
                self.edit_dialog.geom = None
            else:
                self.edit_dialog.geom = list(self.edit_dialog.added_geoms.values())[-1]
                self.select_comboboxes_value()

    @pyqtSlot(int, QgsGeometry)
    def creator_geometry_changed(self, qgsfId, geom):
        """
           Called when feature is changed
           @param qgsfId:      Id of added feature
           @type  qgsfId:      qgis.core.QgsFeature.QgsFeatureId
           @param geom:        geometry of added feature
           @type  geom:        qgis.core.QgsGeometry
        """
        if qgsfId in list(self.edit_dialog.added_geoms.keys()):
            area = geom.area()
            if area < 10:
                iface.messageBar().pushMessage(
                    "INFO",
                    "You've edited the outline to less than 10sqm, are you sure this is correct?",
                    level=QgsMessageBar.INFO,
                    duration=3,
                )
            wkt = geom.exportToWkt()
            if not wkt:
                self.disable_UI_functions()
                self.edit_dialog.geom = None
                return
            sql = general_select.convert_geometry
            result = self.edit_dialog.db._execute(sql, (wkt,))
            geom = result.fetchall()[0][0]
            self.edit_dialog.added_geoms[qgsfId] = geom
            if qgsfId == list(self.edit_dialog.added_geoms.keys())[-1]:
                self.edit_dialog.geom = geom
        else:
            self.error_dialog = ErrorDialog()
            self.error_dialog.fill_report(
                "\n -------------------- WRONG GEOMETRY EDITED ------"
                "-------------- \n\nOnly current added outline can "
                "be edited. Please go to [Edit Geometry] to edit "
                "existing outlines."
            )
            self.error_dialog.show()

    def select_comboboxes_value(self):
        """
            Select the correct combobox value for the geometry
        """
        # capture method
        self.edit_dialog.cmb_capture_method.setCurrentIndex(
            self.edit_dialog.cmb_capture_method.findText("Trace Orthophotography")
        )

        # capture source
        # repopulate capture source cmb
        self.edit_dialog.cmb_capture_source.clear()
        result = self.edit_dialog.db._execute(
            reference_select.capture_source_area_intersect_geom,
            (self.edit_dialog.geom,),
        )
        result = result.fetchall()
        if len(result) == 0:
            iface.messageBar().pushMessage(
                "Capture Source",
                "The new outline overlaps with no capture source area, please reset.",
                level=QgsMessageBar.WARNING,
                duration=6,
            )
        elif len(result) > 1:
            iface.messageBar().pushMessage(
                "Capture Source",
                "The new outline overlaps with multiple capture source areas, please manually choose one.",
                level=QgsMessageBar.INFO,
                duration=6,
            )
            text_max = ""
            for item in result:
                text = "- ".join(item)
                self.edit_dialog.cmb_capture_source.addItem(text)
                if len(text) > len(text_max):
                    text_max = text
            self.fix_truncated_dropdown(self.edit_dialog.cmb_capture_source, text_max)
            self.edit_dialog.cmb_capture_source.showPopup()
        else:
            text = "- ".join(result[0])
            self.edit_dialog.cmb_capture_source.addItem(text)
            self.fix_truncated_dropdown(self.edit_dialog.cmb_capture_source, text)

        # territorial authority
        sql = "SELECT buildings_reference.territorial_authority_intersect_polygon(%s);"
        result = self.edit_dialog.db._execute(sql, (self.edit_dialog.geom,))
        index = self.edit_dialog.ids_ta.index(result.fetchall()[0][0])
        self.edit_dialog.cmb_ta.setCurrentIndex(index)

        # town locality
        sql = "SELECT buildings_reference.town_city_intersect_polygon(%s);"
        result = self.edit_dialog.db._execute(sql, (self.edit_dialog.geom,))
        index = self.edit_dialog.ids_town.index(result.fetchall()[0][0])
        self.edit_dialog.cmb_town.setCurrentIndex(index)

        # suburb locality
        sql = "SELECT buildings_reference.suburb_locality_intersect_polygon(%s);"
        result = self.edit_dialog.db._execute(sql, (self.edit_dialog.geom,))
        index = self.edit_dialog.ids_suburb.index(result.fetchall()[0][0])
        self.edit_dialog.cmb_suburb.setCurrentIndex(index)


class EditAttribute(ProductionChanges):
    """
        Class to edit attributes in buildings.building_outlines
        Inherits ProductionChanges
    """

    def __init__(self, edit_dialog):
        """Constructor"""
        ProductionChanges.__init__(self, edit_dialog)
        # set editing to edit polygon
        iface.actionSelect().trigger()
        selecttools = iface.attributesToolBar().findChildren(QToolButton)
        # selection actions
        iface.building_toolbar.addSeparator()
        for sel in selecttools:
            if sel.text() == "Select Feature(s)":
                for a in sel.actions()[0:3]:
                    iface.building_toolbar.addAction(a)
        iface.building_toolbar.show()
        self.msgbox_remove = self.confirmation_dialog_box("remove")

        self.disable_UI_functions()

        if len(self.editing_layer.selectedFeatures()) > 0:
            if self.is_correct_selections():
                self.get_selections()
                self.enable_UI_functions()
                self.populate_edit_comboboxes()
                self.select_comboboxes_value()
            else:
                self.edit_dialog.ids = []
                self.edit_dialog.building_outline_id = None
                self.disable_UI_functions()

    @pyqtSlot(bool)
    def edit_save_clicked(self, commit_status):
        """
            When production frame btn_edit_save clicked
        """
        self.edit_dialog.db.open_cursor()

        capture_method_id, capture_source_id, lifecycle_stage_id, suburb, town, t_a = (
            self.get_comboboxes_values()
        )

        if len(self.edit_dialog.ids) > 0:
            for i in self.edit_dialog.ids:
                sql = "SELECT buildings.building_outlines_update_attributes(%s, %s, %s, %s, %s, %s, %s);"
                self.edit_dialog.db.execute_no_commit(
                    sql,
                    (
                        i,
                        capture_method_id,
                        capture_source_id,
                        lifecycle_stage_id,
                        suburb,
                        town,
                        t_a,
                    ),
                )
                sql = "SELECT buildings.building_outlines_update_modified_date(%s);"
                self.edit_dialog.db.execute_no_commit(sql, (i,))
        self.disable_UI_functions()

        if commit_status:
            self.edit_dialog.db.commit_open_cursor()
            self.edit_dialog.ids = []
            self.edit_dialog.building_outline_id = None

    @pyqtSlot()
    def edit_reset_clicked(self):
        """
            When production frame btn_edit_reset clicked
        """
        self.edit_dialog.ids = []
        self.edit_dialog.building_outline_id = None
        # restart editing
        iface.actionSelect().trigger()
        iface.activeLayer().removeSelection()
        # reset and disable comboboxes
        self.disable_UI_functions()

    @pyqtSlot(list, list, bool)
    def selection_changed(self, added, removed, cleared):
        """
           Called when feature is selected
        """
        # If no outlines are selected the function will return
        if len(self.editing_layer.selectedFeatures()) == 0:
            self.edit_dialog.ids = []
            self.edit_dialog.building_outline_id = None
            self.disable_UI_functions()
            return
        if self.is_correct_selections():
            self.get_selections()
            self.enable_UI_functions()
            self.populate_edit_comboboxes()
            self.select_comboboxes_value()
        else:
            self.edit_dialog.ids = []
            self.edit_dialog.building_outline_id = None
            self.disable_UI_functions()

    @pyqtSlot()
    def end_lifespan(self, commit_status):
        # get the dataset id and dates of the most recent supplied dataset
        if not self.confirm(self.msgbox_remove):
            return
        dates = self.edit_dialog.db._execute(
            bulk_load_select.supplied_dataset_latest_id_and_dates
        )
        dates = dates.fetchone()

        # get list of building_ids from building_outline_ids
        building_ids = []
        for outline in self.edit_dialog.ids:
            result = self.edit_dialog.db._execute(
                buildings_select.building_id_by_building_outline_id, (outline,)
            )
            building_ids.append(result.fetchone()[0])

        # if the current supplied dataset is not in compare
        is_bulk_loaded = dates[1] is None and dates[2] is None
        is_compared = dates[1] is not None and dates[2] is None
        is_published = dates[1] is not None and dates[2] is not None
        if is_bulk_loaded or is_published:
            if self.edit_dialog.db._open_cursor is None:
                self.edit_dialog.db.open_cursor()
            # end lifespan in use table
            sql = "SELECT buildings.building_use_update_end_lifespan(%s);"
            self.edit_dialog.db.execute_no_commit(sql, (building_ids,))
            # end lifespan in name table
            sql = "SELECT buildings.building_name_update_end_lifespan(%s);"
            self.edit_dialog.db.execute_no_commit(sql, (building_ids,))
            # end lifespan in building outlines table
            sql = "SELECT buildings.building_outlines_update_end_lifespan(%s);"
            result = self.edit_dialog.db.execute_no_commit(sql, (self.edit_dialog.ids,))
            # end lifespan in buildings table
            sql = "SELECT buildings.buildings_update_end_lifespan(%s);"
            self.edit_dialog.db.execute_no_commit(sql, (building_ids,))
            if commit_status:
                self.edit_dialog.db.commit_open_cursor()
                self.edit_dialog.ids = []
                self.edit_dialog.building_outline_id = None
                self.editing_layer.removeSelection()
                iface.mapCanvas().refreshAllLayers()

        # if current is in compare
        elif is_compared:
            bool_delete = True
            for outline in self.edit_dialog.ids:
                # see if outline in existing_subset_extracts
                dataset = self.edit_dialog.db._execute(
                    bulk_load_select.existing_subset_extracts_dataset_by_building_outline_id,
                    (outline,),
                )
                dataset = dataset.fetchone()
                # if the outline is in existing_subset_extracts
                if dataset:
                    # if the dataset the outline relates to is the current dataset
                    if dataset[0] == dates[0]:
                        # check if the bulk_loaded_outline is in removed table
                        removed_count = self.edit_dialog.db._execute(
                            bulk_load_select.removed_count_by_building_outline_id,
                            (outline,),
                        )
                        removed_count = removed_count.fetchone()
                        if removed_count[0] == 0:
                            # if it isn't error
                            self.error_dialog = ErrorDialog()
                            self.error_dialog.fill_report(
                                "\n -------------------- BUILDING HAS RELATIONSHIP ------"
                                "-------------- \n\nYou cannot delete this outline as it has"
                                " a relationship with a current bulk loaded outline, first remove "
                                "this relationship and then try again."
                            )
                            self.error_dialog.show()
                            bool_delete = False
                            break
            # if able to delete outlines
            if bool_delete:
                if self.edit_dialog.db._open_cursor is None:
                    self.edit_dialog.db.open_cursor()
                # end lifespan in use table
                sql = "SELECT buildings.building_use_update_end_lifespan(%s);"
                self.edit_dialog.db.execute_no_commit(sql, (building_ids,))
                # end lifespan in name table
                sql = "SELECT buildings.building_name_update_end_lifespan(%s);"
                self.edit_dialog.db.execute_no_commit(sql, (building_ids,))
                # remove outline from removed table
                sql = "SELECT buildings_bulk_load.removed_delete_existing_outlines(%s);"
                self.edit_dialog.db.execute_no_commit(sql, (self.edit_dialog.ids,))
                # remove outline from exisitng subset extracts table
                sql = "SELECT buildings_bulk_load.existing_subset_extracts_remove_by_building_outline_id(%s);"
                self.edit_dialog.db.execute_no_commit(sql, (self.edit_dialog.ids,))
                # end lifespan in building outlines table
                sql = "SELECT buildings.building_outlines_update_end_lifespan(%s);"
                result = self.edit_dialog.db.execute_no_commit(
                    sql, (self.edit_dialog.ids,)
                )
                # end lifespan in buildings table
                sql = "SELECT buildings.buildings_update_end_lifespan(%s);"
                self.edit_dialog.db.execute_no_commit(sql, (building_ids,))
                if commit_status:
                    self.edit_dialog.db.commit_open_cursor()
                    self.edit_dialog.ids = []
                    self.edit_dialog.building_outline_id = None
                    self.editing_layer.removeSelection()
                    iface.mapCanvas().refreshAllLayers()

    def is_correct_selections(self):
        """
            Check if the selections meet the requirement
        """
        feats = []
        for feature in self.editing_layer.selectedFeatures():
            ls = []
            ls.append(feature.attributes()[2])
            ls.append(feature.attributes()[3])
            ls.append(feature.attributes()[4])
            ls.append(feature.attributes()[5])
            ls.append(feature.attributes()[6])
            ls.append(feature.attributes()[7])
            if ls not in feats:
                feats.append(ls)
        # if selected features have different attributes (not allowed)
        if len(feats) > 1:
            self.error_dialog = ErrorDialog()
            self.error_dialog.fill_report(
                "\n ---- MULTIPLE NON IDENTICAL FEATURES SELEC"
                "TED ---- \n\n Can only edit attributes of mul"
                "tiple features when all existing attributes a"
                "re identical."
            )
            self.error_dialog.show()
            return False
        # if all selected features have the same attributes (allowed)
        elif len(feats) == 1:
            return True
        return False

    def get_selections(self):
        """
            Return the selection values
        """
        self.edit_dialog.ids = [
            feat.id() for feat in self.editing_layer.selectedFeatures()
        ]
        self.edit_dialog.building_outline_id = [
            feat.id() for feat in self.editing_layer.selectedFeatures()
        ][0]
        building_feat = [feat for feat in self.editing_layer.selectedFeatures()][0]
        building_geom = building_feat.geometry()
        # convert to correct format
        wkt = building_geom.exportToWkt()
        sql = general_select.convert_geometry
        result = self.edit_dialog.db._execute(sql, (wkt,))
        self.edit_dialog.geom = result.fetchall()[0][0]

    def select_comboboxes_value(self):
        """
            Select the correct combobox value for the geometry
        """
        # lifeycle stage
        result = self.edit_dialog.db._execute(
            buildings_select.lifecycle_stage_value_by_building_outline_id,
            (self.edit_dialog.building_outline_id,),
        )
        result = result.fetchall()[0][0]
        self.edit_dialog.cmb_lifecycle_stage.setCurrentIndex(
            self.edit_dialog.cmb_lifecycle_stage.findText(result)
        )

        # capture method
        result = self.edit_dialog.db._execute(
            common_select.capture_method_value_by_building_outline_id,
            (self.edit_dialog.building_outline_id,),
        )
        result = result.fetchall()[0][0]
        self.edit_dialog.cmb_capture_method.setCurrentIndex(
            self.edit_dialog.cmb_capture_method.findText(result)
        )

        # capture source
        result = self.edit_dialog.db._execute(
            common_select.capture_source_group_value_external_by_building_outline_id,
            (self.edit_dialog.building_outline_id,),
        )
        result = result.fetchall()[0]
        text = "- ".join(result)
        self.edit_dialog.cmb_capture_source.setCurrentIndex(
            self.edit_dialog.cmb_capture_source.findText(text)
        )

        # suburb
        result = self.edit_dialog.db._execute(
            reference_select.suburb_locality_suburb_4th_by_building_outline_id,
            (self.edit_dialog.building_outline_id,),
        )
        result = result.fetchall()[0][0]
        self.edit_dialog.cmb_suburb.setCurrentIndex(
            self.edit_dialog.cmb_suburb.findText(result)
        )

        # town city
        result = self.edit_dialog.db._execute(
            reference_select.town_city_name_by_building_outline_id,
            (self.edit_dialog.building_outline_id,),
        )
        result = result.fetchall()
        if result:
            self.edit_dialog.cmb_town.setCurrentIndex(
                self.edit_dialog.cmb_town.findText(result[0][0])
            )
        else:
            self.edit_dialog.cmb_town.setCurrentIndex(0)

        # territorial Authority
        result = self.edit_dialog.db._execute(
            reference_select.territorial_authority_name_by_building_outline_id,
            (self.edit_dialog.building_outline_id,),
        )
        result = result.fetchall()[0][0]
        self.edit_dialog.cmb_ta.setCurrentIndex(
            self.edit_dialog.cmb_ta.findText(result)
        )


class EditGeometry(ProductionChanges):
    """
        Class to edit outlines in buildings.building_outlines
        Inherits ProductionChanges
    """

    def __init__(self, edit_dialog):
        """Constructor"""
        ProductionChanges.__init__(self, edit_dialog)
        iface.actionToggleEditing().trigger()
        # set editing to edit polygon
        iface.actionNodeTool().trigger()
        selecttools = iface.attributesToolBar().findChildren(QToolButton)
        # selection actions
        iface.building_toolbar.addSeparator()
        for sel in selecttools:
            if sel.text() == "Select Feature(s)":
                for a in sel.actions()[0:3]:
                    iface.building_toolbar.addAction(a)
        # editing actions
        iface.building_toolbar.addSeparator()
        for dig in iface.digitizeToolBar().actions():
            if dig.objectName() in ["mActionNodeTool", "mActionMoveFeature"]:
                iface.building_toolbar.addAction(dig)
        # advanced Actions
        iface.building_toolbar.addSeparator()
        for adv in iface.advancedDigitizeToolBar().actions():
            if adv.objectName() in [
                "mActionUndo",
                "mActionRedo",
                "mActionReshapeFeatures",
                "mActionOffsetCurve",
            ]:
                iface.building_toolbar.addAction(adv)
        iface.building_toolbar.show()

        self.disable_UI_functions()

    @pyqtSlot(bool)
    def edit_save_clicked(self, commit_status):
        """
            When production frame btn_edit_save clicked
        """
        self.edit_dialog.db.open_cursor()

        capture_method_id, _, _, _, _, _ = self.get_comboboxes_values()

        for key in self.edit_dialog.geoms:
            sql = "SELECT buildings.building_outlines_update_shape(%s, %s);"
            self.edit_dialog.db.execute_no_commit(
                sql, (self.edit_dialog.geoms[key], key)
            )

            self.edit_dialog.db.execute_no_commit(
                "SELECT buildings.building_outlines_update_capture_method(%s, %s)",
                (key, capture_method_id),
            )
            sql = "SELECT buildings.building_outlines_update_modified_date(%s);"
            self.edit_dialog.db.execute_no_commit(sql, (key,))
        self.disable_UI_functions()
        if commit_status:
            self.edit_dialog.db.commit_open_cursor()
            self.edit_dialog.geoms = {}

    @pyqtSlot()
    def edit_reset_clicked(self):
        """
            When production frame btn_edit_reset clicked
        """
        self.editing_layer.geometryChanged.disconnect(self.geometry_changed)
        iface.actionCancelEdits().trigger()
        self.editing_layer.geometryChanged.connect(self.geometry_changed)
        self.edit_dialog.geoms = {}
        # restart editing
        iface.actionToggleEditing().trigger()
        iface.actionNodeTool().trigger()
        iface.activeLayer().removeSelection()
        # reset and disable comboboxes
        self.disable_UI_functions()

    @pyqtSlot(int, QgsGeometry)
    def geometry_changed(self, qgsfId, geom):
        """
           Called when feature is changed
           @param qgsfId:      Id of added feature
           @type  qgsfId:      qgis.core.QgsFeature.QgsFeatureId
           @param geom:        geometry of added feature
           @type  geom:        qgis.core.QgsGeometry
        """
        # get new feature geom and convert to correct format
        wkt = geom.exportToWkt()
        sql = general_select.convert_geometry
        result = self.edit_dialog.db._execute(sql, (wkt,))
        self.edit_dialog.geom = result.fetchall()[0][0]
        result = self.edit_dialog.db._execute(
            buildings_select.building_outline_shape_by_building_outline_id, (qgsfId,)
        )
        area = geom.area()
        if area < 10:
            iface.messageBar().pushMessage(
                "INFO",
                "You've edited the outline to less than 10sqm, are you sure this is correct?",
                level=QgsMessageBar.INFO,
                duration=3,
            )
        result = result.fetchall()[0][0]
        if self.edit_dialog.geom == result:
            if qgsfId in list(self.edit_dialog.geoms.keys()):
                del self.edit_dialog.geoms[qgsfId]
            self.disable_UI_functions()
        else:
            self.edit_dialog.geoms[qgsfId] = self.edit_dialog.geom
            self.enable_UI_functions()
            self.populate_edit_comboboxes()
            self.select_comboboxes_value()

        self.edit_dialog.activateWindow()
        self.edit_dialog.btn_edit_save.setDefault(True)

    @pyqtSlot(int)
    def creator_feature_added(self, qgsfId):
        pass  # Future Enhancement

    def select_comboboxes_value(self):
        """
            Select the correct combobox value for the geometry
        """
        self.edit_dialog.cmb_capture_method.setCurrentIndex(
            self.edit_dialog.cmb_capture_method.findText("Trace Orthophotography")
        )
