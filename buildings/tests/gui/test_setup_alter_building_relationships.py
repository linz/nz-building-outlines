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

    Tests: Alter Building Relationship GUI setup confirm default settings

 ***************************************************************************/
"""

import unittest

from qgis.core import QgsProject
from qgis.utils import plugins

from PyQt4.QtCore import QModelIndex


class SetUpAlterRelationshipsTest(unittest.TestCase):
    """
    Test Alter Building Relationship GUI initial
    setup confirm default settings
    """
    @classmethod
    def setUpClass(cls):
        """Runs at TestCase init."""
        if not plugins.get('roads'):
            pass
        else:
            cls.road_plugin = plugins.get('roads')
            if cls.road_plugin.is_active is False:
                cls.road_plugin.main_toolbar.actions()[0].trigger()
                cls.dockwidget = cls.road_plugin.dockwidget
            else:
                cls.dockwidget = cls.road_plugin.dockwidget
            if not plugins.get('buildings'):
                pass
            else:
                cls.building_plugin = plugins.get('buildings')
                cls.building_plugin.main_toolbar.actions()[0].trigger()

    @classmethod
    def tearDownClass(cls):
        """Runs at TestCase teardown."""
        cls.road_plugin.dockwidget.close()

    def setUp(self):
        """Runs before each test."""
        self.road_plugin = plugins.get('roads')
        self.building_plugin = plugins.get('buildings')
        self.dockwidget = self.road_plugin.dockwidget
        self.menu_frame = self.building_plugin.menu_frame
        self.menu_frame.cmb_add_outline.setCurrentIndex(0)
        self.menu_frame.cmb_add_outline.setCurrentIndex(1)
        self.menu_frame.cmb_add_outline.setCurrentIndex(0)
        self.alter_relationships_frame = self.dockwidget.current_frame

    def tearDown(self):
        """Runs after each test."""
        self.alter_relationships_frame.btn_cancel.click()

    def test_bulk_load_gui_set_up(self):
        """ Initial set up of the frame """
        self.assertTrue(self.alter_relationships_frame.btn_remove_slt.isEnabled())
        self.assertTrue(self.alter_relationships_frame.btn_remove_all.isEnabled())
        self.assertTrue(self.alter_relationships_frame.btn_clear_slt.isEnabled())
        self.assertTrue(self.alter_relationships_frame.btn_unlink_all.isEnabled())
        self.assertTrue(self.alter_relationships_frame.btn_clear_slt2.isEnabled())
        self.assertTrue(self.alter_relationships_frame.btn_relink_all.isEnabled())
        self.assertTrue(self.alter_relationships_frame.btn_remove_slt.isEnabled())
        self.assertTrue(self.alter_relationships_frame.btn_matched.isEnabled())
        self.assertTrue(self.alter_relationships_frame.btn_related.isEnabled())
        self.assertTrue(self.alter_relationships_frame.btn_save.isEnabled())
        self.assertTrue(self.alter_relationships_frame.btn_cancel.isEnabled())

        row_count = self.alter_relationships_frame.tbl_original.model().rowCount(QModelIndex())
        self.assertTrue(row_count == 0)

        row_count = self.alter_relationships_frame.lst_existing.model().rowCount(QModelIndex())
        self.assertTrue(row_count == 0)

        row_count = self.alter_relationships_frame.lst_bulk.model().rowCount(QModelIndex())
        self.assertTrue(row_count == 0)

    def test_layer_registry(self):
        """ Layer registry has the correct components """
        layer_bool = True
        root = QgsProject.instance().layerTreeRoot()
        group = root.findGroup('Building Tool Layers')
        layers = group.findLayers()
        layer_name = ['added_bulk_load_in_edit', 'removed_existing_in_edit',
                      'matched_existing_in_edit', 'matched_bulk_load_in_edit',
                      'related_existing_in_edit', 'related_bulk_load_in_edit',
                      'added_outlines', 'removed_outlines', 'matched_existing_outlines',
                      'matched_bulk_load_outlines', 'related_existing_outlines',
                      'related_bulk_load_outlines', 'bulk_load_outlines', 'existing_subset_extracts']
        for layer in layers:
            if layer.layer().name() not in layer_name:
                layer_bool = False

        self.assertEqual(len([layer for layer in layers]), len(layer_name))
        self.assertTrue(layer_bool)


suite = unittest.TestLoader().loadTestsFromTestCase(SetUpAlterRelationshipsTest)
unittest.TextTestRunner(verbosity=2).run(suite)
