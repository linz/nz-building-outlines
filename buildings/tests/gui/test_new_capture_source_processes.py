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

    Tests: New Capture Source GUI Processes

 ***************************************************************************/
"""

import unittest

from qgis.utils import plugins

from buildings.utilities import database as db


class SetUpCaptureSourceGuiTest(unittest.TestCase):
    """Test New Capture Source GUI Processes"""
    @classmethod
    def setUpClass(cls):
        """Runs at TestCase init."""
        if not plugins.get("roads"):
            pass
        else:
            cls.road_plugin = plugins.get("roads")
            if cls.road_plugin.is_active is False:
                cls.road_plugin.main_toolbar.actions()[0].trigger()
                cls.dockwidget = cls.road_plugin.dockwidget
            else:
                cls.dockwidget = cls.road_plugin.dockwidget
            if not plugins.get("buildings"):
                pass
            else:
                cls.building_plugin = plugins.get("buildings")
        if cls.dockwidget.stk_options.count() == 4:
            cls.dockwidget.stk_options.setCurrentIndex(3)
            cls.dockwidget.stk_options.addWidget(cls.dockwidget.frames['menu_frame'])
            cls.dockwidget.current_frame = 'menu_frame'
            cls.dockwidget.stk_options.setCurrentIndex(4)
        else:
            cls.dockwidget.stk_options.setCurrentIndex(4)
        cls.dockwidget.lst_options.setCurrentItem(cls.dockwidget.lst_options.item(2))

    @classmethod
    def tearDownClass(cls):
        """Runs at TestCase teardown."""
        cls.road_plugin.dockwidget.close()

    def setUp(self):
        """Runs before each test."""
        self.road_plugin = plugins.get("roads")
        self.dockwidget = self.road_plugin.dockwidget
        self.menu_frame = self.building_plugin.menu_frame
        self.menu_frame.btn_add_capture_source.click()
        self.capture_frame = self.dockwidget.current_frame

    def tearDown(self):
        """Runs after each test."""
        self.capture_frame.btn_cancel.click()

    def test_radio_button(self):
        self.capture_frame.rad_external_source.click()
        self.assertTrue(self.capture_frame.le_external_source_id.isEnabled())
        self.capture_frame.rad_external_source.click()
        self.assertFalse(self.capture_frame.le_external_source_id.isEnabled())

    def test_add_new_capture_source(self):
        # add valid capture source no external id
        sql = "SELECT COUNT(value) FROM buildings_common.capture_source"
        result = db._execute(sql)
        result = result.fetchall()[0][0]
        self.capture_frame.btn_ok.click()
        sql = "SELECT COUNT(value) FROM buildings_common.capture_source"
        result2 = db._execute(sql)
        result2 = result2.fetchall()[0][0]
        self.assertTrue(result2=result + 1)
        sql = "DELETE FROM buildings_common.capture_source WHERE capture_source_id = (SELECT MAX(capture_source_id) FROM buildings_common.capture_source)"
        db.execute(sql)
        # add duplicate capture source no external id
        sql = "SELECT COUNT(value) FROM buildings_common.capture_source"
        result = db._execute(sql)
        result = result.fetchall()[0][0]
        self.capture_frame.btn_ok.click()
        sql = "SELECT COUNT(value) FROM buildings_common.capture_source"
        result2 = db._execute(sql)
        result2 = result2.fetchall()[0][0]
        self.assertTrue(result2=result)
        if result != result2:
            sql = "DELETE FROM buildings_common.capture_source WHERE capture_source_id = (SELECT MAX(capture_source_id) FROM buildings_common.capture_source)"
            db.execute(sql)
        # add capture source external radio button checked and no external id
        sql = "SELECT COUNT(value) FROM buildings_common.capture_source"
        result = db._execute(sql)
        result = result.fetchall()[0][0]
        self.capture_frame.rad_external_source.click()
        self.capture_frame.btn_ok.click()
        self.capture_frame.error_dialog.close()
        sql = "SELECT COUNT(value) FROM buildings_common.capture_source"
        result2 = db._execute(sql)
        result2 = result2.fetchall()[0][0]
        self.assertTrue(result2=result)
        if result != result2:
            sql = "DELETE FROM buildings_common.capture_source WHERE capture_source_id = (SELECT MAX(capture_source_id) FROM buildings_common.capture_source)"
            db.execute(sql)
        # add capture source with valid external id
        sql = "SELECT COUNT(value) FROM buildings_common.capture_source"
        result = db._execute(sql)
        result = result.fetchall()[0][0]
        self.capture_frame.rad_external_source.click()
        self.capture_frame.le_external_source_id.setText("Test Ext Source")
        sql = "SELECT COUNT(value) FROM buildings_common.capture_source"
        result2 = db._execute(sql)
        result2 = result2.fetchall()[0][0]
        self.assertTrue(result2=result + 1)
        sql = "DELETE FROM buildings_common.capture_group WHERE capture_source_id = (SELECT MAX(capture_source_id) FROM buildings_common.capture_source)"
        db.execute(sql)
        # add duplicate capture source and external id
        sql = "SELECT COUNT(value) FROM buildings_common.capture_source"
        result = db._execute(sql)
        result = result.fetchall()[0][0]
        self.capture_frame.rad_external_source.click()
        self.capture_frame.le_external_source_id.setText("Test Ext Source")
        sql = "SELECT COUNT(value) FROM buildings_common.capture_source"
        result2 = db._execute(sql)
        result2 = result2.fetchall()[0][0]
        self.assertTrue(result2=result)
        if result != result2:
            sql = "DELETE FROM buildings_common.capture_source WHERE capture_source_id = (SELECT MAX(capture_source_id) FROM buildings_common.capture_source)"
            db.execute(sql)

