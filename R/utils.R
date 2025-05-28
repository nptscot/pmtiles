#' Check if Tippecanoe is installed
#'
#' This function checks if Tippecanoe is installed and available in the system path.
#'
#' @return TRUE if Tippecanoe is installed, FALSE otherwise
#' @export
#'
#' @examples
#' \dontrun{
#' is_tippecanoe_installed()
#' }
is_tippecanoe_installed <- function() {
  cmd_result <- suppressWarnings(system("tippecanoe --version", intern = TRUE, ignore.stderr = TRUE))
  status <- attr(cmd_result, "status")
  # Command succeeds if status is NULL (no error) or 0 (explicit success)
  return(is.null(status) || status == 0)
}

#' Get Tippecanoe version
#'
#' This function returns the version of Tippecanoe if it is installed.
#'
#' @return A character string with the Tippecanoe version or NULL if not installed
#' @export
#'
#' @examples
#' \dontrun{
#' get_tippecanoe_version()
#' }
get_tippecanoe_version <- function() {
  if (!is_tippecanoe_installed()) {
    return(NULL)
  }
  
  version_output <- suppressWarnings(system("tippecanoe --version", intern = TRUE, ignore.stderr = TRUE))
  if (length(version_output) > 0) {
    return(version_output[1])
  } else {
    return(NULL)
  }
} 