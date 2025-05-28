#' @keywords internal
"_PACKAGE"

#' PMTiles: Create PMTiles with Tippecanoe in R
#'
#' The pmtiles package provides a simple interface to create PMTiles using the Tippecanoe
#' command-line tool. PMTiles is a file format for efficiently storing map tiles as a single file.
#'
#' @section Main Functions:
#' \itemize{
#'   \item \code{\link{create_pmtiles}}: Create PMTiles with full control over parameters
#'   \item \code{\link{pmtiles}}: Create PMTiles with simplified parameters
#'   \item \code{\link{is_tippecanoe_installed}}: Check if Tippecanoe is installed
#'   \item \code{\link{get_tippecanoe_version}}: Get the installed Tippecanoe version
#' }
#'
#' @section Installation:
#' This package requires Tippecanoe to be installed on your system.
#' See \url{https://github.com/felt/tippecanoe} for installation instructions.
#'
#' @docType package
#' @name pmtiles-package
NULL 