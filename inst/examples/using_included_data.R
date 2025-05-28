library(pmtiles)
library(sf)

# Get information about the included edinburgh_centre dataset
data(edinburgh_centre)
str(edinburgh_centre)

# Create a temporary GeoJSON file from the included data
temp_geojson = tempfile(fileext = ".geojson")
sf::st_write(edinburgh_centre, temp_geojson, delete_dsn = TRUE)

# Create PMTiles from the included data
output_dir = "output"
if (!dir.exists(output_dir)) {
  dir.create(output_dir)
}

# Create PMTiles using the temporary GeoJSON file
pmtiles(
  input_file = temp_geojson,
  output_folder = output_dir,
  output_name = "edinburgh_example",
  attribution = "City of Edinburgh | pmtiles R package"
)

# Check if the PMTiles file was created
output_file = file.path(output_dir, "edinburgh_example.pmtiles")
if (file.exists(output_file)) {
  message("PMTiles file created successfully: ", output_file)
  file_size = file.size(output_file) / 1024 / 1024  # Convert to MB
  message("File size: ", round(file_size, 2), " MB")
} else {
  message("Failed to create PMTiles file")
} 