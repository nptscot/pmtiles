
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pmtiles: Create PMTiles with Tippecanoe in R

<!-- badges: start -->

[![R-CMD-check](https://github.com/nptscot/pmtiles/workflows/R-CMD-check/badge.svg)](https://github.com/nptscot/pmtiles/actions)
<!-- badges: end -->

The `pmtiles` package provides a simple interface to create PMTiles
using the Tippecanoe command-line tool. PMTiles is a file format for
efficiently storing map tiles as a single file.

## Installation

You can install the development version of pmtiles from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("nptscot/pmtiles")
```

### Prerequisites

This package requires [Tippecanoe](https://github.com/felt/tippecanoe)
to be installed on your system. Please follow the installation
instructions on the Tippecanoe GitHub page.

You can check if Tippecanoe is installed and get its version:

``` r
library(pmtiles)
```

Alternatively, you can load the package with the following for local
development:

``` r
devtools::load_all()
```

``` r
# Check if Tippecanoe is installed
is_tippecanoe_installed()
```

## Quick Start

The simplest way to create PMTiles is to use the `pmtiles()` function:

``` r
library(pmtiles)

# Create PMTiles from a GeoJSON file
pmtiles("your_file.geojson")
```

This will create a PMTiles file in the `./pmtiles` directory with
sensible defaults.

## Working with the Included Dataset

The package includes an example dataset for Edinburgh:

``` r
# Load the dataset
data(edinburgh_centre)

# Check the structure
class(edinburgh_centre)
#> [1] "sf"         "data.frame"

# See the first few features
head(edinburgh_centre[, 1:2])
#>     osm_id  highway
#> 4  2429890 tertiary
#> 5  2429892 tertiary
#> 18 2954058 tertiary
#> 24 2956310 tertiary
#> 25 2956311 tertiary
#> 26 2956313 tertiary
```

To create PMTiles from this dataset:

``` r
# Create a temporary GeoJSON file
temp_geojson = tempfile(fileext = ".geojson")
sf::st_write(edinburgh_centre, temp_geojson, delete_dsn = TRUE)

# Create PMTiles
pmtiles(
  input_file = temp_geojson,
  output_name = "edinburgh_example",
  attribution = "City of Edinburgh | pmtiles R package"
)
```

## Advanced Usage

For more control over the PMTiles creation process, use the
`create_pmtiles()` function:

``` r
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

# Order features by a specific variable
create_pmtiles(
  input_file = "path/to/your/data.geojson",
  output_folder = "output/directory",
  output_name = "my_tiles",
  order_by = "all_fastest_bicycle_go_dutch"
)
```

## License

This project is licensed under the MIT License.
