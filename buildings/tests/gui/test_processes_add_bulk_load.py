# -*- coding: utf-8 -*-
"""
################################################################################
#
# Copyright 2018 Crown copyright (c)
# Land Information New Zealand and the New Zealand Government.
# All rights reserved
#
# This program is released under the terms of the 3 clause BSD license. See the
# LICENSE file for more information.
#
################################################################################

    Tests: Add New Bulk Outline Processes

 ***************************************************************************/
"""

import unittest

from PyQt4.QtCore import Qt
from PyQt4.QtTest import QTest
from qgis.core import QgsRectangle, QgsPoint, QgsCoordinateReferenceSystem, QgsMapLayerRegistry
from qgis.gui import QgsMapTool
from qgis.utils import plugins, iface

from buildings.utilities import database as db


class ProcessBulkAddOutlinesTest(unittest.TestCase):
    """Test Add New Bulk Outline GUI Processes"""
    @classmethod
    def setUpClass(cls):
        """Runs at TestCase init."""
        db.connect()

    @classmethod
    def tearDownClass(cls):
        """Runs at TestCase teardown."""
        db.close_connection()

    def setUp(self):
        """Runs before each test."""
        self.building_plugin = plugins.get('buildings')
        self.building_plugin.main_toolbar.actions()[0].trigger()
        self.dockwidget = self.building_plugin.dockwidget
        sub_menu = self.dockwidget.lst_sub_menu
        sub_menu.setCurrentItem(sub_menu.findItems(
            'Bulk Load', Qt.MatchExactly)[0])
        self.bulk_load_frame = self.dockwidget.current_frame
        self.bulk_load_frame.tbtn_edits.setDefaultAction(self.bulk_load_frame.action_add_outline)
        self.bulk_load_frame.tbtn_edits.click()

    def tearDown(self):
        """Runs after each test."""
        self.bulk_load_frame.btn_exit.click()

    def test_ui_on_geometry_drawn(self):
        """UI comboboxes enable when geometry is drawn"""
        # add geom to canvas
        widget = iface.mapCanvas().viewport()
        canvas_point = QgsMapTool(iface.mapCanvas()).toCanvasCoordinates
        QTest.mouseClick(widget, Qt.RightButton,
                         pos=canvas_point(QgsPoint(1747520, 5428152)),
                         delay=-1)
        canvas = iface.mapCanvas()
        selectedcrs = "EPSG:2193"
        target_crs = QgsCoordinateReferenceSystem()
        target_crs.createFromUserInput(selectedcrs)
        canvas.setDestinationCrs(target_crs)
        zoom_rectangle = QgsRectangle(1878035.0, 5555256.0,
                                      1878345.0, 5555374.0)
        canvas.setExtent(zoom_rectangle)
        canvas.refresh()
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878262, 5555314)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878262, 5555290)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878223, 5555290)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878223, 5555314)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.RightButton,
                         pos=canvas_point(QgsPoint(1878223, 5555314)),
                         delay=-1)
        QTest.qWait(1)
        # tests
        self.assertTrue(self.bulk_load_frame.btn_edit_save.isEnabled())
        self.assertTrue(self.bulk_load_frame.btn_edit_reset.isEnabled())
        self.assertTrue(self.bulk_load_frame.btn_edit_cancel.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_capture_method_2.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_capture_source.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_ta.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_town.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_suburb.isEnabled())
        self.assertEqual(self.bulk_load_frame.cmb_capture_method_2.currentText(), 'Trace Orthophotography')
        self.assertEqual(
            self.bulk_load_frame.cmb_capture_source.currentText(),
            '1- Imagery One- NZ Aerial Imagery'
        )
        self.assertEqual(self.bulk_load_frame.cmb_lifecycle_stage.currentText(), 'Current')
        self.assertEqual(self.bulk_load_frame.cmb_ta.currentText(), 'Wellington')
        self.assertEqual(self.bulk_load_frame.cmb_suburb.currentText(), 'Newtown')
        self.assertEqual(self.bulk_load_frame.cmb_town.currentText(), 'Wellington')
        self.bulk_load_frame.db.rollback_open_cursor()

    def test_draw_circle_option(self):
        """Allows user to draw circle using circle button"""
        widget = iface.mapCanvas().viewport()
        canvas_point = QgsMapTool(iface.mapCanvas()).toCanvasCoordinates
        QTest.mouseClick(widget, Qt.RightButton,
                         pos=canvas_point(QgsPoint(1747520, 5428152)),
                         delay=-1)
        canvas = iface.mapCanvas()
        selectedcrs = "EPSG:2193"
        target_crs = QgsCoordinateReferenceSystem()
        target_crs.createFromUserInput(selectedcrs)
        canvas.setDestinationCrs(target_crs)
        zoom_rectangle = QgsRectangle(1878035.0, 5555256.0,
                                      1878345.0, 5555374.0)
        canvas.setExtent(zoom_rectangle)
        canvas.refresh()
        self.bulk_load_frame.btn_circle.click()
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878300.4, 5555365.6)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878301.7, 5555367.3)),
                         delay=-1)
        self.assertTrue(self.bulk_load_frame.btn_edit_save.isEnabled())
        self.assertTrue(self.bulk_load_frame.btn_edit_reset.isEnabled())
        self.assertTrue(self.bulk_load_frame.btn_edit_cancel.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_capture_method_2.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_capture_source.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_ta.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_town.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_suburb.isEnabled())
        self.assertEqual(self.bulk_load_frame.cmb_capture_method_2.currentText(), 'Trace Orthophotography')

    def test_reset_clicked(self):
        """Indexes are reset and comboxes disabled when reset is called"""
        # add geom to canvas
        widget = iface.mapCanvas().viewport()
        canvas_point = QgsMapTool(iface.mapCanvas()).toCanvasCoordinates
        QTest.mouseClick(widget, Qt.RightButton,
                         pos=canvas_point(QgsPoint(1747520, 5428152)),
                         delay=-1)
        canvas = iface.mapCanvas()
        selectedcrs = "EPSG:2193"
        target_crs = QgsCoordinateReferenceSystem()
        target_crs.createFromUserInput(selectedcrs)
        canvas.setDestinationCrs(target_crs)
        zoom_rectangle = QgsRectangle(1878035.0, 5555256.0,
                                      1878345.0, 5555374.0)
        canvas.setExtent(zoom_rectangle)
        canvas.refresh()
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878262, 5555314)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878262, 5555290)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878223, 5555290)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878223, 5555314)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.RightButton,
                         pos=canvas_point(QgsPoint(1878223, 5555314)),
                         delay=-1)
        QTest.qWait(1)
        # tests
        self.assertTrue(self.bulk_load_frame.btn_edit_save.isEnabled())
        self.assertTrue(self.bulk_load_frame.btn_edit_reset.isEnabled())
        self.assertTrue(self.bulk_load_frame.btn_edit_cancel.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_capture_method_2.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_capture_source.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_ta.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_town.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_suburb.isEnabled())
        self.assertEqual(self.bulk_load_frame.cmb_capture_method_2.currentText(), 'Trace Orthophotography')

        # change indexes of comboboxes
        self.bulk_load_frame.cmb_capture_method_2.setCurrentIndex(1)
        self.bulk_load_frame.cmb_capture_source.setCurrentIndex(0)
        self.bulk_load_frame.cmb_ta.setCurrentIndex(1)
        self.bulk_load_frame.cmb_town.setCurrentIndex(0)
        self.bulk_load_frame.cmb_suburb.setCurrentIndex(1)
        # click reset button
        self.bulk_load_frame.btn_edit_reset.click()
        # check geom removed from canvas
        self.assertEqual(len(self.bulk_load_frame.added_building_ids), 0)
        # check comboxbox indexes reset to 0
        self.assertEqual(self.bulk_load_frame.cmb_capture_method_2.currentIndex(), -1)
        self.assertEqual(self.bulk_load_frame.cmb_capture_source.currentIndex(), -1)
        self.assertEqual(self.bulk_load_frame.cmb_ta.currentIndex(), -1)
        self.assertEqual(self.bulk_load_frame.cmb_town.currentIndex(), -1)
        self.assertEqual(self.bulk_load_frame.cmb_suburb.currentIndex(), -1)
        # check comboboxes disabled
        self.assertFalse(self.bulk_load_frame.btn_edit_save.isEnabled())
        self.assertFalse(self.bulk_load_frame.btn_edit_reset.isEnabled())
        self.assertTrue(self.bulk_load_frame.btn_edit_cancel.isEnabled())
        self.assertFalse(self.bulk_load_frame.cmb_capture_method_2.isEnabled())
        self.assertFalse(self.bulk_load_frame.cmb_capture_source.isEnabled())
        self.assertFalse(self.bulk_load_frame.cmb_ta.isEnabled())
        self.assertFalse(self.bulk_load_frame.cmb_town.isEnabled())
        self.assertFalse(self.bulk_load_frame.cmb_suburb.isEnabled())
        self.bulk_load_frame.db.rollback_open_cursor()

    def test_new_outline_insert(self):
        """Data added to correct tables when save clicked"""
        sql = 'SELECT COUNT(bulk_load_outline_id) FROM buildings_bulk_load.bulk_load_outlines;'
        result = db._execute(sql)
        result = result.fetchall()[0][0]
        sql = 'SELECT COUNT(bulk_load_outline_id) FROM buildings_bulk_load.added;'
        added_result = db._execute(sql)
        added_result = added_result.fetchall()[0][0]
        # add geom
        widget = iface.mapCanvas().viewport()
        canvas_point = QgsMapTool(iface.mapCanvas()).toCanvasCoordinates
        QTest.mouseClick(widget, Qt.RightButton,
                         pos=canvas_point(QgsPoint(1747520, 5428152)),
                         delay=-1)
        canvas = iface.mapCanvas()
        selectedcrs = "EPSG:2193"
        target_crs = QgsCoordinateReferenceSystem()
        target_crs.createFromUserInput(selectedcrs)
        canvas.setDestinationCrs(target_crs)
        zoom_rectangle = QgsRectangle(1878035.0, 5555256.0,
                                      1878345.0, 5555374.0)
        canvas.setExtent(zoom_rectangle)
        canvas.refresh()
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878262, 5555314)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878262, 5555290)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878223, 5555290)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878223, 5555314)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.RightButton,
                         pos=canvas_point(QgsPoint(1878223, 5555314)),
                         delay=-1)
        QTest.qWait(1)
        # tests
        self.assertTrue(self.bulk_load_frame.btn_edit_save.isEnabled())
        self.assertTrue(self.bulk_load_frame.btn_edit_reset.isEnabled())
        self.assertTrue(self.bulk_load_frame.btn_edit_cancel.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_capture_method_2.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_capture_source.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_ta.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_town.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_suburb.isEnabled())
        self.assertEqual(self.bulk_load_frame.cmb_capture_method_2.currentText(), 'Trace Orthophotography')
        # change indexes of comboboxes
        self.bulk_load_frame.cmb_capture_source.setCurrentIndex(0)
        self.bulk_load_frame.cmb_ta.setCurrentIndex(0)
        self.bulk_load_frame.cmb_town.setCurrentIndex(0)
        self.bulk_load_frame.cmb_suburb.setCurrentIndex(0)
        self.bulk_load_frame.change_instance.edit_save_clicked(False)
        sql = 'SELECT COUNT(bulk_load_outline_id) FROM buildings_bulk_load.bulk_load_outlines;'
        result2 = db._execute(sql)
        result2 = result2.fetchall()[0][0]
        self.assertEqual(result2, result + 1)
        sql = 'SELECT COUNT(bulk_load_outline_id) FROM buildings_bulk_load.added;'
        added_result2 = db._execute(sql)
        added_result2 = added_result2.fetchall()[0][0]
        self.assertEqual(added_result2, added_result + 1)
        self.bulk_load_frame.db.rollback_open_cursor()

    def test_edit_new_outline(self):
        """Geometry successfully saved when newly created geometry changed."""
        sql = 'SELECT COUNT(bulk_load_outline_id) FROM buildings_bulk_load.bulk_load_outlines;'
        result = db._execute(sql)
        result = result.fetchall()[0][0]
        sql = 'SELECT COUNT(bulk_load_outline_id) FROM buildings_bulk_load.added;'
        added_result = db._execute(sql)
        added_result = added_result.fetchall()[0][0]
        # add geom
        widget = iface.mapCanvas().viewport()
        canvas_point = QgsMapTool(iface.mapCanvas()).toCanvasCoordinates
        QTest.mouseClick(widget, Qt.RightButton,
                         pos=canvas_point(QgsPoint(1747520, 5428152)),
                         delay=-1)
        canvas = iface.mapCanvas()
        selectedcrs = "EPSG:2193"
        target_crs = QgsCoordinateReferenceSystem()
        target_crs.createFromUserInput(selectedcrs)
        canvas.setDestinationCrs(target_crs)
        zoom_rectangle = QgsRectangle(1878035.0, 5555256.0,
                                      1878345.0, 5555374.0)
        canvas.setExtent(zoom_rectangle)
        canvas.refresh()
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878262, 5555314)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878262, 5555290)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878223, 5555290)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878223, 5555314)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.RightButton,
                         pos=canvas_point(QgsPoint(1878223, 5555314)),
                         delay=-1)
        QTest.qWait(1)

        iface.actionNodeTool().trigger()
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878223, 5555314)),
                         delay=-1)
        QTest.mousePress(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878223, 5555314)),
                         delay=-1)
        QTest.mouseRelease(widget, Qt.LeftButton,
                           pos=canvas_point(QgsPoint(1878200, 5555350)),
                           delay=-1)
        QTest.qWait(1)

        self.bulk_load_frame.change_instance.edit_save_clicked(False)
        sql = 'SELECT COUNT(bulk_load_outline_id) FROM buildings_bulk_load.bulk_load_outlines;'
        result2 = db._execute(sql)
        result2 = result2.fetchall()[0][0]
        self.assertEqual(result2, result + 1)
        sql = 'SELECT COUNT(bulk_load_outline_id) FROM buildings_bulk_load.added;'
        added_result2 = db._execute(sql)
        added_result2 = added_result2.fetchall()[0][0]
        self.assertEqual(added_result2, added_result + 1)
        self.bulk_load_frame.db.rollback_open_cursor()

    def test_edit_existing_outline_fails(self):
        """Editing fails when the existing outlines geometry changed."""
        # add geom
        widget = iface.mapCanvas().viewport()
        canvas_point = QgsMapTool(iface.mapCanvas()).toCanvasCoordinates
        QTest.mouseClick(widget, Qt.RightButton,
                         pos=canvas_point(QgsPoint(1747520, 5428152)),
                         delay=-1)
        canvas = iface.mapCanvas()
        selectedcrs = "EPSG:2193"
        target_crs = QgsCoordinateReferenceSystem()
        target_crs.createFromUserInput(selectedcrs)
        canvas.setDestinationCrs(target_crs)
        zoom_rectangle = QgsRectangle(1878035.0, 5555256.0,
                                      1878345.0, 5555374.0)
        canvas.setExtent(zoom_rectangle)
        canvas.refresh()
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878262, 5555314)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878262, 5555290)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878223, 5555290)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878223, 5555314)),
                         delay=-1)
        QTest.mouseClick(widget, Qt.RightButton,
                         pos=canvas_point(QgsPoint(1878223, 5555314)),
                         delay=-1)
        QTest.qWait(1)

        iface.actionNodeTool().trigger()
        QTest.mouseClick(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878231.71, 5555331.38)),
                         delay=-1)
        QTest.mousePress(widget, Qt.LeftButton,
                         pos=canvas_point(QgsPoint(1878231.71, 5555331.38)),
                         delay=-1)
        QTest.mouseRelease(widget, Qt.LeftButton,
                           pos=canvas_point(QgsPoint(1878250, 5555350)),
                           delay=-1)
        QTest.qWait(1)

        self.assertTrue(self.bulk_load_frame.error_dialog.isVisible())
        self.bulk_load_frame.error_dialog.close()

    def test_disabled_on_layer_removed(self):
        """When key layer is removed from registry check options are disabled (#87)"""
        layer = QgsMapLayerRegistry.instance().mapLayersByName('bulk_load_outlines')[0]
        QgsMapLayerRegistry.instance().removeMapLayer(layer.id())
        self.assertFalse(self.bulk_load_frame.btn_edit_save.isEnabled())
        self.assertFalse(self.bulk_load_frame.btn_edit_reset.isEnabled())
        self.assertFalse(self.bulk_load_frame.btn_edit_cancel.isEnabled())
        self.assertFalse(self.bulk_load_frame.cmb_capture_method_2.isEnabled())
        self.assertFalse(self.bulk_load_frame.cmb_capture_source.isEnabled())
        self.assertFalse(self.bulk_load_frame.cmb_ta.isEnabled())
        self.assertFalse(self.bulk_load_frame.cmb_town.isEnabled())
        self.assertFalse(self.bulk_load_frame.cmb_suburb.isEnabled())
        self.assertFalse(self.bulk_load_frame.cmb_capture_method_2.isEnabled())
        self.assertFalse(self.bulk_load_frame.tbtn_edits.isEnabled())
        self.assertFalse(self.bulk_load_frame.btn_alter_rel.isEnabled())
        self.assertFalse(self.bulk_load_frame.btn_publish.isEnabled())
        self.assertFalse(self.bulk_load_frame.btn_compare_outlines.isEnabled())
        self.assertTrue(self.bulk_load_frame.btn_exit.isEnabled())
        iface.messageBar().popWidget()
