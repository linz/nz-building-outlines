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

    Tests: Reference Data GUI setup confirm default settings

 ***************************************************************************/
"""

import unittest

from PyQt4.QtCore import Qt, QTimer
from PyQt4.QtGui import QMessageBox
from qgis.utils import plugins

from buildings.utilities import database as db


class SetUpReferenceData(unittest.TestCase):
    """Test Reference Data GUI initial setup confirm default settings"""

    def setUp(self):
        """Runs before each test."""
        self.building_plugin = plugins.get('buildings')
        self.building_plugin.main_toolbar.actions()[0].trigger()
        self.dockwidget = self.building_plugin.dockwidget
        sub_menu = self.dockwidget.lst_sub_menu
        sub_menu.setCurrentItem(sub_menu.findItems(
            'Reference Data', Qt.MatchExactly)[0])
        self.reference_frame = self.dockwidget.current_frame

    def tearDown(self):
        """Runs after each test."""
        self.reference_frame.db.rollback_open_cursor()
        self.reference_frame.btn_exit.click()

    def test_suburb_locality_table_update(self):
        """Check buildings_reference.suburb_locality table updates correctly."""
        self.reference_frame.chbx_suburbs.setChecked(True)

        btn_ok = self.reference_frame.msgbox.button(QMessageBox.Ok)
        QTimer.singleShot(500, btn_ok.click)

        self.reference_frame.update_clicked(commit_status=False)

        # deleted suburb locality
        sql_removed = "SELECT count(*)::integer FROM buildings_reference.suburb_locality WHERE external_suburb_locality_id = 104;"
        result = db._execute(sql_removed)
        count_removed = result.fetchone()[0]
        self.assertEqual(count_removed, 0)
        # new suburb locality
        sql_added = "SELECT count(*)::integer FROM buildings_reference.suburb_locality WHERE external_suburb_locality_id = 105;"
        result = db._execute(sql_added)
        count_added = result.fetchone()[0]
        self.assertEqual(count_added, 1)
        # updated suburb locality
        sql_updated = "SELECT suburb_4th FROM buildings_reference.suburb_locality WHERE external_suburb_locality_id = 101;"
        result = db._execute(sql_updated)
        name_updated = result.fetchone()[0]
        self.assertEqual(name_updated, 'Kelburn North')
