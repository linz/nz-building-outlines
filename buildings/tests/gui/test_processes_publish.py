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

    Tests: Publish Outlines Button Click Confirm Processes

 ***************************************************************************/
"""

import unittest

from PyQt4.QtCore import Qt
from qgis.utils import plugins

from buildings.utilities import database as db


class ProcessPublish(unittest.TestCase):
    """
    Test Add Production Outline GUI initial
    setup confirm default settings
    """
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
        self.bulk_load_frame.db.open_cursor()

    def tearDown(self):
        """Runs after each test."""
        self.bulk_load_frame.btn_exit.click()

    def test_load_building_outlines(self):
        """Publish loads outlines to buildings schema"""
        self.bulk_load_frame.publish_clicked(False)
        sql = 'SELECT count(*) FROM buildings.building_outlines;'
        result = db._execute(sql)
        result = result.fetchall()
        self.assertEqual(result[0][0], 66)
        sql = 'SELECT count(*) FROM buildings.building_outlines WHERE end_lifespan IS NULL;'
        result = db._execute(sql)
        result = result.fetchall()
        self.assertEqual(result[0][0], 33)
        self.bulk_load_frame.db.rollback_open_cursor()

    def test_gui_on_publish_clicked(self):
        """Publish GUI changes"""
        self.bulk_load_frame.publish_clicked(False)
        self.assertEqual(self.bulk_load_frame.current_dataset, None)
        self.assertFalse(self.bulk_load_frame.btn_publish.isEnabled())
        self.assertFalse(self.bulk_load_frame.btn_compare_outlines.isEnabled())
        self.assertFalse(self.bulk_load_frame.btn_alter_rel.isEnabled())
        self.assertTrue(self.bulk_load_frame.ml_outlines_layer.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_capture_method.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_organisation.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_capture_src_grp.isEnabled())
        self.assertTrue(self.bulk_load_frame.le_data_description.isEnabled())
        self.assertFalse(self.bulk_load_frame.rad_external_id.isChecked())
        self.assertFalse(self.bulk_load_frame.fcb_external_id.isEnabled())
        self.assertTrue(self.bulk_load_frame.cmb_external_id.isEnabled())
        self.bulk_load_frame.db.rollback_open_cursor()

    def test_deleted_outlines_on_publish(self):
        """Check outlines that are deleted during QA the outlines are not added to building_outlines layer"""
        sql = 'UPDATE buildings_bulk_load.bulk_load_outlines SET bulk_load_status_id = 3 WHERE bulk_load_outline_id = 2025 OR bulk_load_outline_id = 2030 OR bulk_load_outline_id = 2026 OR bulk_load_outline_id = 2027 OR bulk_load_outline_id = 2028 OR bulk_load_outline_id = 2029;'
        db._execute(sql)
        self.bulk_load_frame.publish_clicked(False)
        sql = 'SELECT end_lifespan FROM buildings.building_outlines WHERE building_outline_id = 1031;'
        result = db._execute(sql)
        result = result.fetchall()[0][0]
        self.assertEqual(result, None)
        sql = 'SELECT count(*) FROM buildings.building_outlines;'
        result = db._execute(sql)
        result = result.fetchall()[0][0]
        self.assertEqual(result, 60)
        self.bulk_load_frame.db.rollback_open_cursor()

    def test_not_removed_outlines_on_publish(self):
        """Check removed outlines that are tagged as 'not removed' are not deleted from building outlines layer"""
        sql = 'UPDATE buildings_bulk_load.removed SET qa_status_id = 5 WHERE building_outline_id = 1004;'
        db._execute(sql)
        self.bulk_load_frame.publish_clicked(False)
        sql = 'SELECT end_lifespan FROM buildings.building_outlines WHERE building_outline_id = 1004;'
        result = db._execute(sql)
        result = result.fetchall()[0][0]
        self.assertEqual(result, None)
        self.bulk_load_frame.db.rollback_open_cursor()
