#' Simple PMTiles creation
#'
#' A simplified interface for creating PMTiles from GeoJSON files.
#'
#' @param input_file Path to the input GeoJSON file, or an sf object
#' @param output_folder Path to the output folder (default: "./pmtiles")
#' @param output_name Name of the output file without extension (default: derived from input filename)
#' @param ... Additional parameters to pass to create_pmtiles()
#'
#' @return The exit code of the Tippecanoe command
#' @export
#'

pmtiles = function(input_file, 
                  output_folder = "./pmtiles", 
                  output_name = NULL,
                  ...) {
  
  # Handle different input types
  temp_file_created = FALSE
  original_input = input_file
  
  # Check if input is an sf object
  if (inherits(input_file, "sf")) {
    temp_geojson = tempfile(fileext = ".geojson")
    sf::st_write(input_file, temp_geojson, delete_dsn = TRUE, quiet = TRUE)
    input_file = temp_geojson
    temp_file_created = TRUE
    
    # Derive output name from a generic name if not provided
    if (is.null(output_name)) {
      output_name = "sf_data"
    }
  } else {
    # Check if input file exists
    if (!file.exists(input_file)) {
      stop("Input file does not exist: ", input_file)
    }
    
    # Check if input file is not GeoJSON and convert if needed
    file_ext = tolower(tools::file_ext(input_file))
    if (file_ext != "geojson" && file_ext != "json") {
      # Read the file and convert to temporary GeoJSON
      temp_geojson = tempfile(fileext = ".geojson")
      data = sf::st_read(input_file, quiet = TRUE)
      sf::st_write(data, temp_geojson, delete_dsn = TRUE, quiet = TRUE)
      input_file = temp_geojson
      temp_file_created = TRUE
    }
    
    # Derive output name from input filename if not provided
    if (is.null(output_name)) {
      output_name = tools::file_path_sans_ext(basename(original_input))
    }
  }
  
  # Ensure cleanup of temporary file
  if (temp_file_created) {
    on.exit(unlink(input_file), add = TRUE)
  }
  
  # Call the main function with sensible defaults
  create_pmtiles(
    input_file = input_file,
    output_folder = output_folder,
    output_name = output_name,
    ...
  )
} 