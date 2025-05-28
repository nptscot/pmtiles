#' Create PMTiles from GeoJSON
#'
#' This function creates PMTiles from a GeoJSON file using the Tippecanoe command-line tool.
#'
#' @param input_file Path to the input GeoJSON file
#' @param output_folder Path to the output folder
#' @param output_name Name of the output file (without extension)
#' @param layer_name Name of the layer
#' @param attribution Attribution text
#' @param min_zoom Minimum zoom level (default: 6)
#' @param max_zoom Maximum zoom level (default: 13)
#' @param drop_smallest Whether to drop smallest features as needed (default: TRUE)
#' @param max_tile_bytes Maximum tile size in bytes (default: 2000000)
#' @param buffer Buffer size in pixels (default: 5)
#' @param simplification Simplification factor (default: NULL)
#' @param force Whether to overwrite existing files (default: TRUE)
#' @param extra_args Additional arguments to pass to Tippecanoe (default: NULL)
#'
#' @return The exit code of the Tippecanoe command
#' @export
#'
#' @examples
#' \dontrun{
#' create_pmtiles("path/to/input.geojson", "path/to/output", "my_layer")
#' }
create_pmtiles = function(input_file, 
                          output_folder,
                          output_name,
                          layer_name = output_name,
                          attribution = "",
                          min_zoom = 6,
                          max_zoom = 13,
                          drop_smallest = TRUE,
                          max_tile_bytes = 2000000,
                          buffer = 5,
                          simplification = NULL,
                          force = TRUE,
                          extra_args = NULL) {
  
  # Check if Tippecanoe is installed
  if (!is_tippecanoe_installed()) {
    stop("Tippecanoe is not installed or not in the system path. Please install Tippecanoe first.")
  }
  
  # Check if input file exists
  if (!file.exists(input_file)) {
    stop("Input file does not exist: ", input_file)
  }
  
  # Check if sf package is installed
  if (!requireNamespace("sf", quietly = TRUE)) {
    stop("The sf package is required to check CRS. Please install it with install.packages('sf')")
  }
  
  # Check CRS of input file and transform if necessary
  tryCatch({
    data <- sf::st_read(input_file, quiet = TRUE)
    crs <- sf::st_crs(data)
    
    if (is.na(crs$epsg) || crs$epsg != 4326) {
      current_crs <- if(is.na(crs$epsg)) "unknown" else crs$epsg
      message("Input file CRS: ", current_crs, ". Transforming to EPSG:4326 (WGS 84)...")
      
      # Transform to EPSG:4326
      data_transformed <- sf::st_transform(data, crs = 4326)
      
      # Create a temporary file with the transformed data
      temp_file <- tempfile(fileext = ".geojson")
      sf::st_write(data_transformed, temp_file, quiet = TRUE)
      
      # Update input_file to point to the temporary file
      input_file <- temp_file
      
      message("Data transformed to EPSG:4326 and saved to temporary file")
    } else {
      message("CRS check passed: EPSG:4326 (WGS 84)")
    }
  }, error = function(e) {
    stop("Error checking/transforming CRS of input file: ", e$message)
  })
  
  # Create output folder if it doesn't exist
  if (!dir.exists(output_folder)) {
    dir.create(output_folder, recursive = TRUE)
  }
  
  # Build the Tippecanoe command
  cmd_parts <- c()
  
  # Base command with quoted output path
  output_path <- file.path(output_folder, paste0(output_name, ".pmtiles"))
  cmd_parts <- c(cmd_parts, "tippecanoe", "-o", shQuote(output_path))
  
  # Add layer name
  cmd_parts <- c(cmd_parts, "--name", shQuote(layer_name))
  
  # Add layer
  cmd_parts <- c(cmd_parts, "--layer", shQuote(layer_name))
  
  # Add attribution if provided
  if (attribution != "") {
    cmd_parts <- c(cmd_parts, "--attribution", shQuote(attribution))
  }
  
  # Add zoom levels
  cmd_parts <- c(cmd_parts, "--minimum-zoom", as.character(min_zoom))
  cmd_parts <- c(cmd_parts, "--maximum-zoom", as.character(max_zoom))
  
  # Add drop smallest option
  if (drop_smallest) {
    cmd_parts <- c(cmd_parts, "--drop-smallest-as-needed")
  }
  
  # Add max tile bytes
  cmd_parts <- c(cmd_parts, "--maximum-tile-bytes", format(max_tile_bytes, scientific = FALSE))
  
  # Add simplification if provided
  if (!is.null(simplification)) {
    cmd_parts <- c(cmd_parts, "--simplification", format(simplification, scientific = FALSE))
  }
  
  # Add buffer
  cmd_parts <- c(cmd_parts, "--buffer", as.character(buffer))
  
  # Add force option
  if (force) {
    cmd_parts <- c(cmd_parts, "--force")
  }
  
  # Add extra arguments if provided
  if (!is.null(extra_args)) {
    cmd_parts <- c(cmd_parts, extra_args)
  }
  
  # Add input file (quoted)
  cmd_parts <- c(cmd_parts, shQuote(input_file))
  
  # Combine all parts into a single command
  pmtiles_cmd <- paste(cmd_parts, collapse = " ")
  
  # Print the command
  message("Executing command: ", pmtiles_cmd)
  
  # Execute the command
  system(pmtiles_cmd)
} 