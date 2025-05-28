# pmtiles: Create PMTiles with Tippecanoe in R

The `pmtiles` package provides a simple interface to create PMTiles using the Tippecanoe command-line tool. PMTiles is a file format for efficiently storing map tiles as a single file.

## Installation

You can install the development version of pmtiles from GitHub with:

```r
# install.packages("devtools")
devtools::install_github("your-username/pmtiles")
```

### Prerequisites

This package requires [Tippecanoe](https://github.com/felt/tippecanoe) to be installed on your system. Please follow the installation instructions on the Tippecanoe GitHub page.

## Quick Start

The simplest way to create PMTiles is to use the `pmtiles()` function:

```r
library(pmtiles)

# Create PMTiles from a GeoJSON file
pmtiles("path/to/your/data.geojson")
```

This will create a PMTiles file in the `./pmtiles` directory with sensible defaults.

### Advanced Usage

For more control over the PMTiles creation process, use the `create_pmtiles()` function:

```r
library(pmtiles)

# Create PMTiles with custom parameters
create_pmtiles(
  input_file = "path/to/your/data.geojson",
  output_folder = "output/directory",
  output_name = "my_tiles",
  layer_name = "my_layer",
  attribution = "My Organization",
  min_zoom = 6,
  max_zoom = 13,
  drop_smallest = TRUE,
  max_tile_bytes = 2000000,
  buffer = 5,
  simplification = 10,
  force = TRUE
)
```

### Working with Large Data

When working with large GeoJSON files, you may want to clip or filter the data before creating PMTiles. Here's an example using the zonebuilder and sf packages:

```r
library(pmtiles)
library(sf)
library(zonebuilder)

# Create a testing region around Edinburgh with 2 circles
test_region <- zonebuilder::zb_zone("Edinburgh", n_circles = 2)

# Read and clip the data
edinburgh_data <- sf::st_read("data/cbd_layer_city_of_edinburgh.geojson")
clipped_data <- sf::st_intersection(edinburgh_data, test_region)

# Keep only one column of interest
clipped_data <- clipped_data[, c("all_fastest_bicycle_go_dutch")]

# Save to temporary file
clipped_data_path <- tempfile(fileext = ".geojson")
sf::st_write(clipped_data, clipped_data_path)

# Create PMTiles
pmtiles(
  input_file = clipped_data_path,
  output_name = "edinburgh_bike_dutch",
  attribution = "City of Edinburgh"
)
```

### Checking Tippecanoe Installation

You can check if Tippecanoe is installed and get its version:

```r
# Check if Tippecanoe is installed
is_tippecanoe_installed()

# Get Tippecanoe version
get_tippecanoe_version()
```

## License

This project is licensed under the MIT License. 