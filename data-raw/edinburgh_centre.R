library(sf)
library(zonebuilder)

# Create a testing region around Edinburgh with 2 circles
test_region = zonebuilder::zb_zone("Edinburgh", n_circles = 2)

# Path to the original GeoJSON file
original_data_path = "cbd_layer_city_of_edinburgh.geojson"
if (!file.exists(original_data_path)) {
  stop("Original data file not found: ", original_data_path)
}

# Read the data
edinburgh_data = sf::st_read(original_data_path)

# Clip the data with the test region
# Transform to British National Grid (EPSG:27700) for accurate spatial operations
edinburgh_centre = sf::st_intersection(
  edinburgh_data |> sf::st_transform(27700), 
  test_region |> sf::st_transform(27700)
)

# Transform back to WGS84 for general compatibility
edinburgh_centre = sf::st_transform(edinburgh_centre, 4326)

# Create a temporary file path that can be used for PMTiles creation
clipped_data_path = file.path(tempdir(), "edinburgh_centre.geojson")
sf::st_write(edinburgh_centre, clipped_data_path, delete_dsn = TRUE)

# Save the clipped data as an .rda file in the package
usethis::use_data(edinburgh_centre, overwrite = TRUE)
