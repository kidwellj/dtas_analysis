# Development Trust Association Scotland Analysis

This R application represents an ongoing research collaboration between Jeremy Kidwell (UOB) and DTAS. The application takes a series of points representing the whole DTAS network and conducts a series of analyses, illuminating a series of research questions generated by myself and DTAS staff / board members.

I am working here within the style commended by Hadley Wickham in his Advanced R "Style guide" and some of the parameters described in Karl Broman's guide, "[Initial Steps Toward Reproducible Research](http://kbroman.org/steps2rr/)"

# Installation requirements:

Though I am trying very hard to make this reproducible research, there are some datasets which don't have tidy download links. The following must be downloaded from the repositories indicated and placed in the "data" subdirectory

- `data/poi.csv` POI data from digimap. Most academic researchers should be able to aquire it through an institutional subscription from Digimap, [Ordnance Survey Data Download](https://digimap.edina.ac.uk/datadownload/osdownload). The POI set is located under "Boundary and Location Data" under "Points of Interest," "select visible area" for whole UK then download.
- `data/retailpoints_version11_dec17.txt` Retail POI data packaged by GeoLytix, download from here: (https://geolytix.co.uk/?retail_points)
- `data/scotland_laulevel1_2011` from the [Edina Census Easy Download Service](https://borders.ukdataservice.ac.uk/easy_download.html) under Scotland, "Scottish Local Administrative Units Level 1 2011". Click on "Download features in Shapefile format as ZIP file"


# Files:
- `dtas_analysis.R` is the "canonical" R markdown script for this project; `dtas_analysis.Rnw` is updated based on changes to the former and is meant to be used with knitr to export to elegant .tex. This is especially important for tables.
- `community_anchors_2018May19.Rpres` is a presentation delivered on May 19 2018 in which I set out some initial provocations.
- `community_anchors.qgs` is a working document for use in QGIS to conduct analysis on these data sets

Paths in this folder are used mostly for R processing. Towards this end folders have the following significance:

- `data` contains datasets used for analysis.
- `derived_data` contains files which represent modified forms of files in the above path.
- `figures` contains images and visualisations (graphic files) which are generated by R for the final form of the document.
- `cache` isn't included in github but is usually used for working files

Note: none of the contents of the above are included in the github repository unless they are unavailable from an external repository.

Note, code provided here under GPL v. 3 license.