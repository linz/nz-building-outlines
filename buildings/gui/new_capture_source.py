# -*- coding: utf-8 -*-

import os.path

from PyQt4 import uic
from PyQt4.QtGui import QFrame
import qgis

from buildings.gui.error_dialog import ErrorDialog
from buildings.utilities import database as db

db.connect()

FORM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'new_capture_source.ui'))


class NewCaptureSource(QFrame, FORM_CLASS):


    le_external_source = None

    value = ''
    external_source = ''

    def __init__(self, layer_registry, parent=None):
        """Constructor."""
        super(NewCaptureSource, self).__init__(parent)
        self.setupUi(self)
        self.populate_combobox()
        self.le_external_source_id.setDisabled(1)

        self.layer_registry = layer_registry

        # set up signals and slots
        self.btn_ok.clicked.connect(self.ok_clicked)
        self.btn_cancel.clicked.connect(self.cancel_clicked)
        self.rad_external_source.toggled.connect(self.enable_external_source)

    def populate_combobox(self):
        """
        Called on opening of frame populate combobox with capture source group
        """
        sql = 'SELECT value, description FROM buildings_common.capture_source_group'
        result = db._execute(sql)
        ls = result.fetchall()
        for item in ls:
            text = str(item[0]) + '- ' + str(item[1])
            self.cmb_capture_source_group.addItem(text)

    def get_comments(self):
        """
        Returns comment from external source id line edit
        returns None if empty/disabled
        """
        if not self.rad_external_source.isChecked():
            return None
        else:
            return self.le_external_source_id.text()

    def get_combobox_value(self):
        """
        Returns capture source group from combobox
        """
        text = self.cmb_capture_source_group.currentText()
        text_ls = text.split('-')
        return text_ls[0]

    def enable_external_source(self, boolVal):
        """
        Called when external source radiobutton is toggled
        """
        if self.rad_external_source.isChecked():
            self.le_external_source_id.setEnabled(1)
        if not self.rad_external_source.isChecked():
            self.le_external_source_id.clear()
            self.le_external_source_id.setDisabled(1)

    def ok_clicked(self):
        """
        Called when ok button clicked
        """
        # get external source id
        self.external_source = self.get_comments()
        # if no external source is entered  and radio button selected open error dialog
        if self.rad_external_source.isChecked():
            if self.external_source == '':
                self.error_dialog = ErrorDialog()
                self.error_dialog.fill_report('\n -------------------- EMPTY VALUE FIELD -------------------- \n\n If no external source id deselect external source radio button')
                self.error_dialog.show()
                return
            if len(self.external_source) > 250:
                self.error_dialog = ErrorDialog()
                self.error_dialog.fill_report('\n -------------------- VALUE TOO LONG -------------------- \n\n Enter less than 250 characters')
                self.error_dialog.show()
                return
        # get type
        self.value = self.get_combobox_value()
        # call insert function
        self.insert_capture_source(self.value, self.external_source)

    def cancel_clicked(self):
        """
        Called when cancel button is clicked
        """
        from buildings.gui.menu_frame import MenuFrame
        dw = qgis.utils.plugins['roads'].dockwidget
        dw.stk_options.removeWidget(dw.stk_options.currentWidget())
        dw.new_widget(MenuFrame(self.layer_registry))

    def insert_capture_source(self, value, external_source):
        """
            add values to the capture_source table.
            capture_source_id is autogenerated
        """
        # find capture source group id based on capture source group value
        sql = 'SELECT capture_source_group_id FROM buildings_common.capture_source_group WHERE buildings_common.capture_source_group.value = %s;'
        result = db._execute(sql, data=(value,))
        capture_source_group_id = result.fetchall()[0][0]

        # check if capture source exists in table
        sql = 'SELECT * FROM buildings_common.capture_source WHERE buildings_common.capture_source.external_source_id = %s OR buildings_common.capture_source.capture_source_group_id = %s;'
        result = db._execute(sql, data=(external_source, capture_source_group_id))
        ls = result.fetchall()
        if len(ls) > 0:
            to_add = True
            for item in ls:
                # if capture source with same CSG and ES exists
                if item[1] == capture_source_group_id:
                    if item[2] == external_source:
                        self.error_dialog = ErrorDialog()
                        self.error_dialog.fill_report(' ')
                        self.error_dialog.fill_report(' \n capture source value exists in table')
                        self.error_dialog.show()
                        to_add = False
            # if no entry with external source and capture source group add to table
            if to_add:
                sql = 'SELECT capture_source_id FROM buildings_common.capture_source;'
                result = db._execute(sql)
                length = len(result.fetchall())
                id = length + 1
                sql = 'INSERT INTO buildings_common.capture_source(capture_source_id, capture_source_group_id, external_source_id)VALUES(%s, %s, %s)'
                db.execute(sql, data=(id, capture_source_group_id, external_source))
                self.le_external_source_id.clear()

        # if sql querry returns nothing add to table
        elif len(ls) == 0:
            sql = 'SELECT capture_source_id FROM buildings_common.capture_source;'
            result = db._execute(sql)
            length = len(result.fetchall())
            id = length + 1
            sql = 'INSERT INTO buildings_common.capture_source(capture_source_id, capture_source_group_id, external_source_id)VALUES(%s, %s, %s)'
            db.execute(sql, data=(id, capture_source_group_id, external_source))
            self.le_external_source_id.clear()
