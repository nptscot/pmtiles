library(pmtiles)

# Check if Tippecanoe is installed
if (is_tippecanoe_installed()) {
  cat("Tippecanoe is installed:", get_tippecanoe_version(), "\n")
  
  # Create a sample GeoJSON file
  sample_geojson <- tempfile(fileext = ".geojson")
  
  # Write a simple point feature to the GeoJSON file
  cat('{
    "type": "FeatureCollection",
    "features": [
      {
        "type": "Feature",
        "properties": {
          "name": "Sample Point"
        },
        "geometry": {
          "type": "Point",
          "coordinates": [-0.1278, 51.5074]
        }
      }
    ]
  }', file = sample_geojson)
  
  # Create PMTiles from the GeoJSON file
  output_dir <- tempdir()
  
  cat("Creating PMTiles in:", output_dir, "\n")
  
  # Use the simple interface
  pmtiles(
    input_file = sample_geojson,
    output_folder = output_dir,
    attribution = "Example Attribution"
  )
  
  # Check if the file was created
  output_file <- file.path(output_dir, paste0(
    tools::file_path_sans_ext(basename(sample_geojson)), 
    ".pmtiles"
  ))
  
  if (file.exists(output_file)) {
    cat("PMTiles file created successfully:", output_file, "\n")
  } else {
    cat("Failed to create PMTiles file\n")
  }
} else {
  cat("Tippecanoe is not installed. Please install it first.\n")
} 