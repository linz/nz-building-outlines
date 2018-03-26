#/***************************************************************************
# qgis-building-plugin
#
# qgis-buildings-plugin
#							 -------------------
#		begin				: 2018-03-26
#		git sha				: $Format:%H$
#		copyright			: (C) 2018 by LINZ
#		email				:
# ***************************************************************************/


#Add iso code for any locales you want to support here (space separated)
# default is no locales
# LOCALES = af
LOCALES =

# If locales are enabled, set the name of the lrelease binary on your system. If
# you have trouble compiling the translations, you may have to specify the full path to
# lrelease
#LRELEASE = lrelease
#LRELEASE = lrelease-qt4


# translation
SOURCES = \
	buildings/__init__.py \
	buildings/gui/menu_frame.py buildings/gui/new_entry.py buildings/gui/new_capture_source.py buildings/gui/bulk_load_outlines.py buildings/gui/bulk_new_outline.py buildings/gui/production_new_outline.py buildings/gui/error_dialog.py

PLUGINNAME = local_buildings

PY_FILES = \
	buildings/__init__.py \
	buildings/gui/menu_frame.py buildings/gui/new_entry.py buildings/gui/new_capture_source.py buildings/gui/bulk_load_outlines.py buildings/gui/bulk_new_outline.py buildings/gui/production_new_outline.py buildings/gui/error_dialog.py

UI_FILES = buildings/gui/menu.ui buildings/gui/new_entry.ui buildings/gui/new_capture_source.ui buildings/gui/bulk_load_outlines.ui buildings/gui/new_outline_bulk.ui buildings/gui/new_outline_production.ui buildings/gui/error_dialog.ui

EXTRAS = buildings/metadata.txt buildings/__init__.py buildings/plugin.py

ICONS =  buildings/icons/roads_plugin.png

UTILITIES = buildings/utilities/config.py buildings/utilities/database.py buildings/utilities/__init__.py buildings/utilities/layers.py

GUITESTS = buildings/tests/gui/__init__.py buildings/tests/gui/test_menu_gui_initial_setup.py buildings/tests/gui/test_new_entry_gui_initial_setup.py buildings/tests/gui/test_new_capture_source_gui_initial_setup.py

TESTS = buildings/tests/__init__.py

STYLES = buildings/styles/building_blue.qml buildings/styles/building_green.qml buildings/styles/building_orange.qml buildings/styles/building_purple.qml buildings/styles/building_yellow.qml

AF = buildings/gui/i18n/af.ts

COMPILED_RESOURCE_FILES = resources.py

# PLUGIN_UPLOAD = $(c)/plugin_upload.py

RESOURCE_SRC=$(shell grep '^ *<file' resources.qrc | sed 's@</file>@@g;s/.*>//g' | tr '\n' ' ')

QGISDIR=.qgis2

default: compile

compile: $(COMPILED_RESOURCE_FILES)

%.py : %.qrc $(RESOURCES_SRC)
	pyrcc4 -o $*.py  $<

%.qm : %.ts
	$(LRELEASE) $<

test: compile
	python -m unittest discover

deploy: # compile doc transcompile
	@echo
	@echo "------------------------------------------"
	@echo "Deploying plugin to your .qgis2 directory."
	@echo "------------------------------------------"
	# The deploy  target only works on unix like operating system where
	# the Python plugin directory is located at:
	# $HOME/$(QGISDIR)/python/plugins
	mkdir -p $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)
	mkdir -p $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)/gui
	mkdir -p $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)/gui/i18n
	mkdir -p $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)/icons
	mkdir -p $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)/utilities
	mkdir -p $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)/tests
	mkdir -p $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)/tests/gui
	mkdir -p $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)/styles
	cp -vf $(PY_FILES) $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)/gui
	cp -vf $(UI_FILES) $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)/gui
	cp -vf $(AF) $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)/gui/i18n
	cp -vf $(UTILITIES) $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)/utilities
	cp -vf $(GUITESTS) $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)/tests/gui
	cp -vf $(TESTS) $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)/tests
	cp -vf $(STYLES) $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)/styles
	cp -vf $(COMPILED_RESOURCE_FILES) $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)
	cp -vf $(EXTRAS) $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)
	cp -vf $(ICONS) $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)/icons
	# cp -vfr buildings/i18n $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)
	# cp -vfr $(HELP) $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)/help


# The dclean target removes compiled python files from plugin directory
# also deletes any .git entry
dclean:
	@echo
	@echo "-----------------------------------"
	@echo "Removing any compiled python files."
	@echo "-----------------------------------"
	find $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME) -iname "*.pyc" -delete
	find $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME) -iname ".git" -prune -exec rm -Rf {} \;


derase:
	@echo
	@echo "-------------------------"
	@echo "Removing deployed plugin."
	@echo "-------------------------"
	rm -Rf $(HOME)/$(QGISDIR)/python/plugins/$(PLUGINNAME)

zip: deploy dclean
	@echo
	@echo "---------------------------"
	@echo "Creating plugin zip bundle."
	@echo "---------------------------"
	# The zip target deploys the plugin and creates a zip file with the deployed
	# content. You can then upload the zip file on http://plugins.qgis.org
	rm -f $(PLUGINNAME).zip
	cd $(HOME)/$(QGISDIR)/python/plugins; zip -9r $(CURDIR)/$(PLUGINNAME).zip $(PLUGINNAME)

package: compile
	# Create a zip package of the plugin named $(PLUGINNAME).zip.
	# This requires use of git (your plugin development directory must be a
	# git repository).
	# To use, pass a valid commit or tag as follows:
	#   make package VERSION=Version_0.3.2
	@echo
	@echo "------------------------------------"
	@echo "Exporting plugin to zip package.	"
	@echo "------------------------------------"
	rm -f $(PLUGINNAME).zip
	git archive --prefix=$(PLUGINNAME)/ -o $(PLUGINNAME).zip $(VERSION)
	echo "Created package: $(PLUGINNAME).zip"

clean:
	@echo
	@echo "------------------------------------"
	@echo "Removing uic and rcc generated files"
	@echo "------------------------------------"
	rm $(COMPILED_UI_FILES) $(COMPILED_RESOURCE_FILES)
