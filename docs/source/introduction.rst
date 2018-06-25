.. _introduction:

Introduction
=============================

Purpose
-----------------------------

This document provides detailed metadata (data dictionary) for the NZ Building Outlines data published on the LINZ Data Service.

Background
----------------------------


Building outlines have been identified as a dataset of national importance, and influence a multitude of decisions made across New Zealand at both the national and regional levels. It is therefore critical to have a consistent and dynamic dataset available. In 2016 LINZ conducted a pilot project to capture building outlines over three regions of New Zealand (Canterbury, Hawke’s Bay and Waikato). A survey was sent out to assess users’ opinion and determine the usefulness and suitability of the data for their purposes. The majority of the respondents (90%) to the survey agreed that the data is useful for their organisation. Many commented that the data is better than existing data, it is fit for purpose, and has become invaluable when enriched with other datasets. LINZ will continue to procure building outlines aligning with aerial imagery capture. This building outline dataset will provide a foundation for various stakeholders to map risk modelling, environmental assessment, urban development, resilience planning in addition to the visualization and physical location of buildings. 
Over the next decade, the LINZ Topographic Office is working towards its vision of recognising the way location information can help unlock new patterns and knowledge, particularly when it is combined with other types of information. One of our `strategic goals <https://www.linz.govt.nz/about-linz/publications/strategy/topographic-strategy-2015>`_ is to improve national scale datasets and maximize their opportunities for reuse by a variety of national and regional stakeholders.


Description
---------------------------

This dataset consists of building outlines within mainland New Zealand. This is not a complete set and will be added to as new imagery becomes available. Current coverage includes areas in Northland, Waikato, Hawke’s Bay, Manawatu-Whanganui, Tasman, West Coast, Marlborough, Canterbury and Otago (See coverage maps for more detail).

This dataset includes the spatial coverage of building outlines using remotely sensed information. A building outline is a 2D representation of the roof outline of buildings which have been classified from remotely sensed information using a combination of automated and manual processes to extract and orthogonalise building roof outlines. Structures greater than or equal to 10 square meters are captured in this dataset. Each building polygon represents a building outline and this may include spaces such as decks, garages and porches. The building outlines represented in this dataset should not be confused with *building footprints*, which are 2D representations of where a building touches the ground. 

.. figure:: _static/footprint.png
   :scale: 100 %
   :alt: comparison of footprint with building outlines

   Image 1. Example of a building outline versus a building footprint.

The current Topo50 data for buildings is represented by either a `building polygon <https://data.linz.govt.nz/layer/50246-nz-building-polygons-topo-150k/>`_ or a `building point <https://data.linz.govt.nz/layer/50245-nz-building-points-topo-150k/>`_ . A building polygon is used to represent a structure that is large enough to be captured at 1:50,000 scale and has an area of 25m² or greater. The central business districts of large towns and cities is held in the LINZ building data as large building polygons. It is shown on the printed maps as black fill, and is a generalized view, not showing individual buildings, or open spaces between buildings. A building point is used to represent a building with an area too small to be captured as a polygon feature at 1:50,000 scale.

The building outlines data described here represents the outlines of individual buildings as polygons, as visible in the imagery, and not generalized for more urban areas.

Building polygons in the building outlines data are defined by the following criteria:

* Buildings under construction are not captured as building outlines.
* Primary building structures are captured as separate building outline polygons from adjoining building structure polygons.
* Building extensions, sunrooms, balconies, patios and annexes are captured as part of the primary building outline structure if resolution of imagery allows.
* Permanent building structures such as sheds and greenhouses, not attached to a primary building structure, are captured as a separate building outline polygon.
* Adjoining townhouses are not captured as separate structures, but rather as joined primary structures.
* Adjoining commercial buildings are captured as separate building outlines when rooflines allows delineation.
* Building outline polygons captured will be greater than 10m².
* Water tanks are captured as building outlines when their size is at least 16.5 square metres.


Source Imagery
---------------------------

The source imagery is linked via the ``external_source_id`` attribute of building outlines to the ``imagery_survey_id`` of NZ Imagery Surveys. Using this link, additional attributes can be connected to building outlines - for example the dates that the imagery was captured and the accuracy / ground sample distance of the imagery used.

The NZ Imagery Surveys data dictionary is here: https://nz-imagery-surveys.readthedocs.io/en/latest/index.html


Coverage Maps
---------------------------

The NZ Building Outlines dataset is being procured and released in stages. Image 2 shows the current coverage of building outlines available on the `LINZ Data Service <https://data.linz.govt.nz/layer/53413-nz-building-outlines-pilot/>`_. Image 3 shows the upcoming coverage of building outlines available by the end of 2018. Image 4 shows the future coverage of building outlines after the next round of aerial imagery is received.

+-------------------------------------------------------------+-------------------------------------------------------------+-----------------------------------------------------------+
| .. figure:: _static/current_building_outlines_coverage.jpg  | .. figure:: _static/upcoming_building_outlines_coverage.jpg | .. figure:: _static/future_building_outlines_coverage.jpg |
|    :scale: 70%                                              |    :scale: 70%                                              |    :scale: 70%                                            |
|    :alt: current building outlines coverage                 |    :alt: upcoming bulding outlines coverage                 |    :alt: future building outlines coverage                |
|                                                             |                                                             |                                                           |
|    Image 2: Map of current dataset coverage.                |    Image 3: Map of dataset coverage by the end of 2018.     |    Image 4: Map of dataset coverage after future round(s) |
|                                                             |                                                             |    of aerial imagery received.                            |
+-------------------------------------------------------------+-------------------------------------------------------------+-----------------------------------------------------------+



Accuracy Specification
---------------------------

The Building Outlines contain spatial detail reflective of the visible characteristics of building outlines as seen from the source imagery to an accuracy of 1 metre. Outlines are captured in full where they are partially occluded by vegetation or require additional viewer interpretation, and squared off at 90 degrees if the corner angles are between 80-100 degrees.


Valid Geometry
---------------------------

A building outline polygon is considered to have valid geometry if:
* It does not overlap with any other current building outline polygon
* It does not contain any spikes (a series of vertices which create an extremely acute angle)
* It does not contain lines that are intersected with each other
* It can contain polygons with interior rings (holes)
* It does not contain polygons with multiple exterior rings


Formats
---------------------------

Textual data uses UTF-8 character encoding. 

The source geometry of all spatial data uses NZGD2000 / New Zealand Transverse Mercator 2000 (EPSG 2193) as the spatial reference system.



Definitions
---------------------------

.. table::
   :class: manual

+-------------------+----------------------------------------------------------------------+
| Term              | Description                                                          |
+===================+======================================================================+
| Aspatial          | Data that is not related to a spatial geometry                       |
+-------------------+----------------------------------------------------------------------+
| LDS               | LINZ Data Service                                                    |
+-------------------+----------------------------------------------------------------------+
| Building          | A structure generally permanent in nature which has been constructed |
|                   | to meet a specific objective (e.g. housing, storage, and workplace)  |
|                   | and less permanent structures such as caravans and other portable    |
|                   | housing may also be represented.                                     |
+-------------------+----------------------------------------------------------------------+
| Building Outlines | A building outline is a 2D representation of the roof outline of a   |
|                   | building. Structures greater than or equal to 10 square meters are   |
|                   | captured in this dataset.                                            |
+-------------------+----------------------------------------------------------------------+



