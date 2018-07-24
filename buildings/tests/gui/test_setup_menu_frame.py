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

    Tests: Menu GUI menu confirm default settings

 ***************************************************************************/
"""
from qgis.utils import plugins


import unittest

from buildings.utilities import database as db


class SetUpMenuTest(unittest.TestCase):
    """Test Menu GUI initial menu confirm default settings"""
    @classmethod
    def setUpClass(cls):
        """Runs at TestCase init."""
        if not plugins.get('buildings'):
            pass
        else:
            db.connect()
            cls.building_plugin = plugins.get('buildings')
            cls.dockwidget = cls.building_plugin.dockwidget
            cls.building_plugin.main_toolbar.actions()[0].trigger()

    @classmethod
    def tearDownClass(cls):
        """Runs at TestCase teardown."""
        pass

    def setUp(self):
        """Runs before each test."""
        self.building_plugin = plugins.get('buildings')
        self.building_plugin.main_toolbar.actions()[0].trigger()
        self.dockwidget = self.building_plugin.dockwidget
        self.menu_frame = self.building_plugin.menu_frame

    def tearDown(self):
        """Runs after each test"""
        self.dockwidget.close()

    def test_menu_gui_buttons_enabled(self):
        """Buttons are enabled"""
        self.assertTrue(self.menu_frame.btn_new_entry.isEnabled())
        self.assertTrue(self.menu_frame.btn_new_capture_source.isEnabled())
        self.assertTrue(self.menu_frame.btn_bulk_load.isEnabled())
        self.assertTrue(self.menu_frame.btn_production.isEnabled())

    def test_menu_gui_button_names(self):
        """Buttons have correct names"""
        self.assertEqual(self.menu_frame.btn_new_entry.text(),
                         u'Add To Lookup Tables'
                         )
        self.assertEqual(self.menu_frame.btn_new_capture_source.text(),
                         'New Capture Source'
                         )
        self.assertEqual(self.menu_frame.btn_bulk_load.text(),
                         'Bulk Load'
                         )
        self.assertEqual(self.menu_frame.btn_production.text(),
                         'Production'
                         )
