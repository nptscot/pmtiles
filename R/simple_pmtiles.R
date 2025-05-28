#' Simple PMTiles creation
#'
#' A simplified interface for creating PMTiles from GeoJSON files.
#'
#' @param input_file Path to the input GeoJSON file
#' @param output_folder Path to the output folder (default: "./pmtiles")
#' @param output_name Name of the output file without extension (default: derived from input filename)
#' @param ... Additional parameters to pass to create_pmtiles()
#'
#' @return The exit code of the Tippecanoe command
#' @export
#'
#' @examples
#' \dontrun{
#' pmtiles("my_data.geojson")
#' pmtiles("my_data.geojson", attribution = "My Organization")
#' }
pmtiles = function(input_file, 
                  output_folder = "./pmtiles", 
                  output_name = NULL,
                  ...) {
  
  # Check if input file exists
  if (!file.exists(input_file)) {
    stop("Input file does not exist: ", input_file)
  }
  
  # Derive output name from input filename if not provided
  if (is.null(output_name)) {
    output_name = tools::file_path_sans_ext(basename(input_file))
  }
  
  # Call the main function with sensible defaults
  create_pmtiles(
    input_file = input_file,
    output_folder = output_folder,
    output_name = output_name,
    ...
  )
} 