#' Edinburgh Centre Geographic Data
#'
#' A spatial dataset containing geographic features for the central area of Edinburgh.
#' This dataset was created by clipping the larger Edinburgh dataset with a circular
#' region created using the zonebuilder package. It contains various cycling-related
#' attributes used for transportation analysis.
#'
#' @format A sf object with geographic features and associated attributes.
#' \describe{
#'   \item{all_fastest_bicycle_go_dutch}{Cycle network data based on the Go Dutch scenario}
#'   \item{geometry}{The geometric features representing road segments}
#'   \item{...}{Additional attributes carried over from the original dataset}
#' }
#' @source Derived from City of Edinburgh cycling data, clipped to central Edinburgh.
"edinburgh_centre" 