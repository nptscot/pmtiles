library(pmtiles)
library(sf)
library(zonebuilder)
library(usethis)

# Create a data-raw directory for data preparation scripts if not already existing
usethis::use_data_raw()

# Create a testing region around Edinburgh with 2 circles
test_region = zonebuilder::zb_zone("Edinburgh", n_circles = 2)

# Read the original GeoJSON file
# Assuming the file exists in the current directory
original_data_path = "cbd_layer_city_of_edinburgh.geojson"
if (!file.exists(original_data_path)) {
  stop("Original data file not found: ", original_data_path)
}

# Read the data
edinburgh_data = sf::st_read(original_data_path)

# Clip the data with the test region
clipped_data = sf::st_intersection(edinburgh_data |> sf::st_transform(27700), test_region |> sf::st_transform(27700))

# Create a temporary file to save the clipped GeoJSON for PMTiles creation
clipped_data_path = tempfile(fileext = ".geojson")
sf::st_write(clipped_data, clipped_data_path, delete_dsn = TRUE)

# Save the clipped data as an .rda file in the package data folder
edinburgh_centre = clipped_data
usethis::use_data(edinburgh_centre, overwrite = TRUE)

# Create output directory if it doesn't exist
output_dir = "output"
if (!dir.exists(output_dir)) {
  dir.create(output_dir)
}

# Create PMTiles from the clipped data
pmtiles(
  input_file = clipped_data_path,
  output_folder = output_dir,
  output_name = "edinburgh_centre",
  attribution = "City of Edinburgh"
)

# Verify the PMTiles file was created
output_file = file.path(output_dir, "edinburgh_centre.pmtiles")
if (file.exists(output_file)) {
  message("PMTiles file created successfully: ", output_file)
  file_size = file.size(output_file) / 1024 / 1024  # Convert to MB
  message("File size: ", round(file_size, 2), " MB")
} else {
  message("Failed to create PMTiles file")
}

# Create documentation file for the dataset
usethis::use_r("data")
# Now manually edit R/data.R to add documentation for the edinburgh_centre dataset 