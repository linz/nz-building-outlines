# -*- coding: utf-8 -*-

import os.path

from PyQt4 import uic
from PyQt4.QtGui import QFrame

from buildings.gui.new_entry import NewEntry
from buildings.gui.new_capture_source import NewCaptureSource
from buildings.gui.bulk_load_outlines import BulkLoadOutlines
from buildings.gui.bulk_new_outline import BulkNewOutline
from buildings.gui.production_new_outline import ProductionNewOutline
from buildings.utilities import database as db

import qgis

db.connect()

FORM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'menu.ui'))


class MenuFrame(QFrame, FORM_CLASS):

    def __init__(self, layer_registry, parent=None):
        """Constructor."""
        super(MenuFrame, self).__init__(parent)
        self.setupUi(self)
        self.layer_registry = layer_registry

        # set up signals and slots
        self.btn_new_entry.clicked.connect(self.new_entry_clicked)
        self.btn_add_capture_source.clicked.connect(self.add_capture_source_clicked)
        self.btn_load_outlines.clicked.connect(self.load_outlines_clicked)
        self.cmb_add_outline.currentIndexChanged.connect(self.add_outline)

    def new_entry_clicked(self):
        """
        Called when new entry button is clicked
        """
        dw = qgis.utils.plugins['roads'].dockwidget
        dw.stk_options.removeWidget(dw.stk_options.currentWidget())
        dw.new_widget(NewEntry(self.layer_registry))

    def add_capture_source_clicked(self):
        """
        Called when add capture source button is clicked
        """
        dw = qgis.utils.plugins['roads'].dockwidget
        dw.stk_options.removeWidget(dw.stk_options.currentWidget())
        dw.new_widget(NewCaptureSource(self.layer_registry))

    def load_outlines_clicked(self):
        """
        Called when bulk load outlines is clicked
        """
        dw = qgis.utils.plugins['roads'].dockwidget
        dw.stk_options.removeWidget(dw.stk_options.currentWidget())
        dw.new_widget(BulkLoadOutlines(self.layer_registry))

    def add_outline(self):
        """
        Called when index of add outline combobox is changed
        """
        text = self.cmb_add_outline.currentText()
        if text == 'Add New Outline to Supplied Dataset':
            dw = qgis.utils.plugins['roads'].dockwidget
            dw.stk_options.removeWidget(dw.stk_options.currentWidget())
            dw.new_widget(BulkNewOutline(self.layer_registry))
        if text == 'Add New Outline to Production':
            dw = qgis.utils.plugins['roads'].dockwidget
            dw.stk_options.removeWidget(dw.stk_options.currentWidget())
            dw.new_widget(ProductionNewOutline(self.layer_registry))
