# Some opening notes for the stray reader of this code
# This is pretty messy stuff, pulled together in some haste. 
# I'm aware that there are tons of places where repeated code 
# should be set up as libraries - feel free to put in a 
# pull request to this effect!
#
# I'm also aware that my method of creating a table of quantiles 
# is massively inefficient. I'm sure there's a brisk way to 
# do this, but couldn't find anything workable.
# As always, code review much appreciated and comments welcome!

# load libraries needed for operations
require(sp) # required for rgdal
require(rgdal) # required for readOGR
require(GISTools) # required for poly.counts
require(maptools) # required for spTransform
require(xtable) # required for xtables done below
require(RColorBrewer) # required for pretty colours
require(RCurl) # required for dataset downloads using curl

# Preliminaries------------------------------------------------
# Define CRS for here and later--------------------------------
wgs84 = '+proj=longlat +datum=WGS84'
bng = "+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000
+y_0=-100000 +datum=OSGB36 +units=m +no_defs +ellps=airy
+towgs84=446.448,-125.157,542.060,0.1502,0.2470,0.8421,-20.4894"
setwd("~/Dropbox/writing_articles_chapters/201805_dtas")

# Create data directory if needed:
if (dir.exists("data") == FALSE) {
  dir.create("data")
}

if (dir.exists("derivedData") == FALSE) {
  dir.create("derivedData")
}

# 1. Load in datasets

# read in polygon for UK admin boundaries----------------------
download.file("https://census.edina.ac.uk/ukborders/easy_download/prebuilt/shape/Scotland_laulevel1_2011.zip", destfile = "data/Scotland_laulevel1_2011.zip")
unzip("data/Scotland_laulevel1_2011.zip", exdir = "data")
admin <- readOGR("./data", "scotland_laulevel1_2011")
# transform CRS to wgs84 for comparisons below
admin.wgs <- spTransform(admin, CRS("+init=epsg:4326"))

# read in relevant polygons, Scottish Index of Multiple deprivation (already WGS84)
download.file("http://sedsh127.sedsh.gov.uk/Atom_data/ScotGov/ZippedShapefiles/SG_SIMD_2016.zip", destfile = "data/SG_SIMD_2016.zip")
unzip("data/SG_SIMD_2016.zip", exdir = "data")
simd <- readOGR("data", "SG_SIMD_2016")


# Load dtas dataset------------------------------------
# dtas <- read.csv(text=getURL("https://zenodo.org/record/198703/files/dtas_3.2.csv"))
# note: need to upload version 4 to zenodo repository!
dtas <- read.csv("data/dtas_4.0.csv")
coordinates(dtas) <- c("X", "Y")
proj4string(dtas) <- proj4string(simd)
# transform CRS to wgs84 for comparisons below
dtas.wgs <- spTransform(dtas, CRS("+init=epsg:4326"))

# note: need to upload data set to zenodo repository! Note: tbd; simplify to third decimal point for accurate representation of coordinate precision
# Load GWSF dataset ----------------------
gwsf <- readOGR("data", "gwsf_groups_gb_sct")
# transform CRS on admin (from BNG) to wgs84 for comparisons below
gwsf.wgs <- spTransform(gwsf, CRS("+init=epsg:4326"))

# Part I - Generate tables and plots based on SIMD ranks

# Subset SIMD for bottom 5/10/15% by overall rank
# Note: using hardcoded numbers for 5/10/15% figures. This should probably be calculated using a length() routine
simd.bottom15r <- simd[ which(simd$rank < 1047),]
simd.bottom10r <- simd[ which(simd$rank < 698),]
simd.bottom5r <- simd[ which(simd$rank < 349),]

# Subset SIMD for bottom 5/10/15% by income domain rank
simd.bottom15incr <- simd[ which(simd$incrank < 1047),]
simd.bottom10incr <- simd[ which(simd$incrank < 698),]
simd.bottom5incr <- simd[ which(simd$incrank < 349),]

# Subset SIMD for bottom 5/10/15% by income domain rank
simd.bottom15empr <- simd[ which(simd$emprank < 1047),]
simd.bottom10empr <- simd[ which(simd$emprank < 698),]
simd.bottom5empr <- simd[ which(simd$emprank < 349),]

# Now generate subsetted SPDF which only includes dtas points which are
# located in remaining (subsetted) SIMD polygons
dtas.simd.bottom15r <- dtas[!is.na(over(dtas, geometry(simd.bottom15r))),]
dtas.simd.bottom10r <- dtas[!is.na(over(dtas, geometry(simd.bottom10r))),]
dtas.simd.bottom5r <- dtas[!is.na(over(dtas, geometry(simd.bottom5r))),]
gwsf.simd.bottom15r <- gwsf[!is.na(over(gwsf, geometry(simd.bottom15r))),]


# Add data from relevant SIMD polygons for each row in dtas DF
dtas.simd.bottom15r@data <- cbind(dtas.simd.bottom15r@data,over(dtas.simd.bottom15r,simd.bottom15r))
dtas.simd.bottom10r@data <- cbind(dtas.simd.bottom10r@data,over(dtas.simd.bottom10r,simd.bottom10r))
dtas.simd.bottom5r@data <- cbind(dtas.simd.bottom5r@data,over(dtas.simd.bottom5r,simd.bottom5r))

gwsf.simd.bottom15r@data <- cbind(gwsf.simd.bottom15r@data,over(gwsf.simd.bottom15r,simd.bottom15r))

# Convert to dataframe, strip out unnecessary columns, and sort by rank
dtas.simd.bottom15r.tidy <- data.frame("name"=dtas.simd.bottom15r$name,"rank"=dtas.simd.bottom15r$rank)
dtas.simd.bottom15r.tidy <- dtas.simd.bottom15r.tidy[with(dtas.simd.bottom15r.tidy, order(rank)), ]
dtas.simd.bottom10r.tidy <- data.frame("name"=dtas.simd.bottom10r$name,"rank"=dtas.simd.bottom10r$rank)
dtas.simd.bottom10r.tidy <- dtas.simd.bottom10r.tidy[with(dtas.simd.bottom10r.tidy, order(rank)), ]
dtas.simd.bottom5r.tidy <- data.frame("name"=dtas.simd.bottom5r$name,"rank"=dtas.simd.bottom5r$rank)
dtas.simd.bottom5r.tidy <- dtas.simd.bottom5r.tidy[with(dtas.simd.bottom5r.tidy, order(rank)), ]

gwsf.simd.bottom15r.tidy <- data.frame("name"=gwsf.simd.bottom15r$name,"rank"=gwsf.simd.bottom15r$rank)
gwsf.simd.bottom15r.tidy <- gwsf.simd.bottom15r.tidy[with(gwsf.simd.bottom15r.tidy, order(rank)), ]


# Export csv tables for use in other applications
write.csv(dtas.simd.bottom15r, "derivedData/dtas.simd.bottom15r.csv", row.names=FALSE)
write.csv(gwsf.simd.bottom15r, "derivedData/gwsf.simd.bottom15r.csv", row.names=FALSE)


# Generate table for DTAS using xtable for bottom 15% simd rank
xt <- xtable(dtas.simd.bottom15r.tidy, caption = "table of DTAS groups in bottom 15%")

print(xt,
      type = "html",
      tabular.environment = "longtable",
      sanitize.colnames.function = function(x){x},
      include.rownames = FALSE,
      floating = FALSE)

# Generate table for GWSF using xtable for bottom 15% simd rank

xt <- xtable(gwsf.simd.bottom15r.tidy, caption = "table of GWSF groups in bottom 15%")

print(xt,
      type = "html",
      tabular.environment = "longtable",
      sanitize.colnames.function = function(x){x},
      include.rownames = FALSE,
      floating = FALSE)

# End Part I

# Part II - Calculate coincidence of other features

# Load in POI table

# Sadly, this dataset is paywalled by digimap, though most academic researchers should be able to aquire it through 
# an institutional subscription from Digimap, Ordnance Survey Data Download. The POI set is located under 
# "Boundary and Location Data" under "Points of Interest," "select visible area" for whole UK then download.
#
# I'm going to take some shortcuts here, preventing this code from being truly reproducible
# because the poi dataset is really huge - I've already downloaded and filtered to specific codes for features
# so code immediately below is untested. Will need to adjust below to the actual code I'm working with eventually.

## Skip ==>
# poi <- read.csv("data/poi.csv", header = FALSE, sep = "|")
# coordinates(poi) <- c("Feature Easting", "Feature Northing")
# proj4string(poi) <- proj4string(CRS(bng))
## transform CRS on churches (from BNG) to wgs84 for comparisons below
# poi.wgs <- spTransform(poi, CRS(wgs84))

## subsets
#poi.pubs <- poi[!is.na(poi[3] = "01020034")]
#poi.chequecashing <- poi[!is.na(poi[3] = "02090142")]
#poi.pawnbrokers <- poi[!is.na(poi[3] = "02090151")]
#poi.worship <- poi[!is.na(poi[3] = "06340459")]
# ==> to here for now

# Load in retail data from geolytics dataset
# from here: https://geolytix.co.uk/?retail_points
poi.grocery <- read.csv("data/retailpoints_version11_dec17.txt", sep = "\t")
# select useful columns
poi.grocery <- subset(poi.grocery, select = c("retailer", "store_name", "long_wgs", "lat_wgs"))
# convert to spdf
coordinates(poi.grocery) <- c("long_wgs", "lat_wgs")
proj4string(poi.grocery) <- CRS("+init=epsg:4326")
# filter out non-Scottish data
poi.grocery <- poi.grocery[!is.na(over(poi.grocery, geometry(admin.wgs))),]

# Load in British pubs from Ordnance survey dataset
poi.pubs <- read.csv("data/poi_pubs.csv", header = FALSE, sep = "|")
# select useful columns
poi.pubs <- subset(poi.pubs, select = c("V1", "V2", "V3", "V4", "V5"))
# rename columns to tidier names
colnames(poi.pubs) <- c("refnum", "name", "code", "x", "y")
coordinates(poi.pubs) <- c("x", "y")
proj4string(poi.pubs) <- CRS("+init=epsg:27700")
# transform CRS on pubs (from BNG) to wgs84 for comparisons below
poi.pubs.wgs <- spTransform(poi.pubs, CRS("+init=epsg:4326"))
# filter out non-Scottish pubs
poi.pubs.wgs <- poi.pubs.wgs[!is.na(over(poi.pubs.wgs, geometry(admin.wgs))),]

# Load in check cashing from Ordnance survey dataset
poi.checkcashing <- read.csv("data/poi_chequecashing.csv", header = FALSE, sep = "|")
# select useful columns
poi.checkcashing <- subset(poi.checkcashing, select = c("V1", "V2", "V3", "V4", "V5"))
# rename columns to tidier names
colnames(poi.checkcashing) <- c("refnum", "name", "code", "x", "y")
coordinates(poi.checkcashing) <- c("x", "y")
proj4string(poi.checkcashing) <- CRS("+init=epsg:27700")
# transform CRS on pubs (from BNG) to wgs84 for comparisons below
poi.checkcashing.wgs <- spTransform(poi.checkcashing, CRS("+init=epsg:4326"))
# filter out non-Scottish (hah!) check cashing shops
poi.checkcashing.wgs <- poi.checkcashing.wgs[!is.na(over(poi.checkcashing.wgs, geometry(admin.wgs))),]

# Load in pawnbrokers from Ordnance survey dataset
poi.pawnbrokers <- read.csv("data/poi_pawnbrokers.csv", header = FALSE, sep = "|")
# select useful columns
poi.pawnbrokers <- subset(poi.pawnbrokers, select = c("V1", "V2", "V3", "V4", "V5"))
# rename columns to tidier names
colnames(poi.pawnbrokers) <- c("refnum", "name", "code", "x", "y")
coordinates(poi.pawnbrokers) <- c("x", "y")
proj4string(poi.pawnbrokers) <- CRS("+init=epsg:27700")
# transform CRS on pawnbrokers (from BNG) to wgs84 for comparisons below
poi.pawnbrokers.wgs <- spTransform(poi.pawnbrokers, CRS("+init=epsg:4326"))
# filter out non-Scottish (hah!) pawnbrokers
poi.pawnbrokers.wgs <- poi.pawnbrokers.wgs[!is.na(over(poi.pawnbrokers.wgs, geometry(admin.wgs))),]

# Load in places of worship from Ordnance survey dataset
poi.pow <- read.csv("data/poi_pow.csv", header = FALSE, sep = "|")
# select useful columns
poi.pow <- subset(poi.pow, select = c("V1", "V2", "V3", "V4", "V5"))
# rename columns to tidier names
colnames(poi.pow) <- c("refnum", "name", "code", "x", "y")
coordinates(poi.pow) <- c("x", "y")
proj4string(poi.pow) <- CRS("+init=epsg:27700")
# transform CRS on pubs (from BNG) to wgs84 for comparisons below
poi.pow.wgs <- spTransform(poi.pow, CRS("+init=epsg:4326"))
# filter out non-Scottish (hah!) check cashing shops
poi.pow.wgs <- poi.pow.wgs[!is.na(over(poi.pow.wgs, geometry(admin.wgs))),]


# create WGS versions of SIMD subsets from above for comparisons below
simd.bottom15r.wgs <- spTransform(simd.bottom15r, CRS("+init=epsg:4326"))
simd.bottom10r.wgs <- spTransform(simd.bottom10r, CRS("+init=epsg:4326"))
simd.bottom5r.wgs <- spTransform(simd.bottom5r, CRS("+init=epsg:4326"))


# Test it out with a quick plot
plot(poi.pubs.wgs)

# run further subsetting, as above, for specific bands of simd
grocery.simd.bottom15r.wgs <- poi.grocery[!is.na(over(poi.grocery, geometry(simd.bottom15r.wgs))),]
grocery.simd.bottom10r.wgs <- poi.grocery[!is.na(over(poi.grocery, geometry(simd.bottom10r.wgs))),]
grocery.simd.bottom5r.wgs <- poi.grocery[!is.na(over(poi.grocery, geometry(simd.bottom5r.wgs))),]

pubs.simd.bottom15r.wgs <- poi.pubs.wgs[!is.na(over(poi.pubs.wgs, geometry(simd.bottom15r.wgs))),]
pubs.simd.bottom10r.wgs <- poi.pubs.wgs[!is.na(over(poi.pubs.wgs, geometry(simd.bottom10r.wgs))),]
pubs.simd.bottom5r.wgs <- poi.pubs.wgs[!is.na(over(poi.pubs.wgs, geometry(simd.bottom5r.wgs))),]

pawnbrokers.simd.bottom15r.wgs <- poi.pawnbrokers.wgs[!is.na(over(poi.pawnbrokers.wgs, geometry(simd.bottom15r.wgs))),]
checkcashing.simd.bottom15r.wgs <- poi.checkcashing.wgs[!is.na(over(poi.checkcashing.wgs, geometry(simd.bottom15r.wgs))),]
pow.simd.bottom15r.wgs <- poi.pow.wgs[!is.na(over(poi.pow.wgs, geometry(simd.bottom15r.wgs))),]


# Part II.2 Run some calculations on presence for various types of entities

# Calculate total number of DTAS "community anchors" within bottom 15% 
length(dtas.simd.bottom15r$rank) /  length(dtas$name)

# Calculate percentage of total pubs in Scotland located within bottom 15% of IMD by rank
length(pubs.simd.bottom15r.wgs$name) / length(poi.pubs.wgs$name)

# places of worship
length(pow.simd.bottom15r.wgs$name) / length(poi.pow.wgs$name)

# Calculate percentage of total retail grocers in Scotland 
# located within bottom 15% of IMD by rank
length(grocery.simd.bottom15r.wgs$store_name) / length(poi.grocery$store_name)

# drill a bit deeper - morrisons stores
morrisons.scotland <- poi.grocery[poi.grocery$retailer == "Morrisons", ]
morrisons.bottom15r.scotland <- grocery.simd.bottom15r.wgs[grocery.simd.bottom15r.wgs$retailer == "Morrisons", ]
length(morrisons.bottom15r.scotland$store_name) / length(morrisons.scotland)

# sainsburys
sainsburys.scotland <- poi.grocery[poi.grocery$retailer == "Sainsburys", ]
sainsburys.bottom15r.scotland <- grocery.simd.bottom15r.wgs[grocery.simd.bottom15r.wgs$retailer == "Sainsburys", ]
length(sainsburys.bottom15r.scotland$store_name) / length(sainsburys.scotland)

# check cashing
plot(poi.checkcashing.wgs)
par(new=FALSE)
plot(checkcashing.simd.bottom15r.wgs, col="blue")
length(checkcashing.simd.bottom15r.wgs$name) / length(poi.checkcashing.wgs$name)

# pawnbrokers
length(pawnbrokers.simd.bottom15r.wgs$name) / length(poi.pawnbrokers.wgs$name)