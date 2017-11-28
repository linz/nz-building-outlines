# -*- coding: utf-8 -*-
import psycopg2
from qgis.gui import QgsMessageBar
from qgis.core import *

def shp2pgs(layer):


	conn = psycopg2.connect("dbname='test' host='localhost' port = '5432' user='postgres' password='postgres' ")
	cursor = conn.cursor()
	cursor.execute("DROP TABLE IF EXISTS public.%s" %layer.name())
	conn.commit()

	# import layer into database
	uri = "dbname='test' host='localhost' port=5432 user='postgres' password='postgres' table=\"public\".\"%s\" (geom) sql=" %layer.name()
	error = QgsVectorLayerImport.importLayer(layer, uri, "postgres", layer.crs(), False, False)

	if error[0] != 0: 
  	  iface.messageBar().pushMessage(u'Error', error[1], QgsMessageBar.CRITICAL, 5)
	else:
		iface.messageBar().pushMessage(u'Success', u'layer has been loaded into postGIS', QgsMessageBar.SUCCESS, 5)


'''layer = iface.activeLayer()'''