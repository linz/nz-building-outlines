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

    Tests: Edit Production Outline GUI setup confirm default settings

 ***************************************************************************/
"""

import unittest

from qgis.core import QgsProject
from qgis.utils import plugins

from buildings.utilities import database as db


class SetUpEditProduction(unittest.TestCase):
    """
    Test Edit Outline GUI initial
    setup confirm default settings
    """
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
        self.menu_frame.btn_production.click()
        self.production_frame = self.dockwidget.current_frame
        self.production_frame.rad_edit.click()

    def tearDown(self):
        """Runs after each test."""
        self.production_frame.btn_cancel.click()

    def test_production_gui_set_up(self):
        """ Initial set up of the frame """
        self.assertFalse(self.production_frame.btn_save.isEnabled())
        self.assertFalse(self.production_frame.btn_reset.isEnabled())
        self.assertFalse(self.production_frame.cmb_capture_method.isEnabled())
        self.assertFalse(self.production_frame.cmb_capture_source.isEnabled())
        self.assertFalse(self.production_frame.cmb_ta.isEnabled())
        self.assertFalse(self.production_frame.cmb_town.isEnabled())
        self.assertFalse(self.production_frame.cmb_suburb.isEnabled())
        self.assertFalse(self.production_frame.cmb_lifecycle_stage.isEnabled())

    def test_layer_registry(self):
        """ Layer registry has the correct components """
        layer_bool = False
        edit_bool = False
        root = QgsProject.instance().layerTreeRoot()
        group = root.findGroup('Building Tool Layers')
        layers = group.findLayers()
        names = [layer.layer().name() for layer in layers]
        if 'building_outlines' in names and 'historic_outlines' in names:
            layer_bool = True
        for layer in layers:
            if layer.layer().name() == 'building_outlines' and layer.layer().isEditable():
                edit_bool = True

        self.assertTrue(layer_bool)
        self.assertTrue(edit_bool)
