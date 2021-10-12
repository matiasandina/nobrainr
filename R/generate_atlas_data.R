#' @title Generate Atlas Data
#' @description This function generates the atlas data needed to plot. You can use it to generate your own custom plots.
#' @param AP (required) `numeric` AP in mm from bregma. Will be rounded by [roundAP()].
#' @param half `boolean` whether to plot half or full section. Default is TRUE.
#' @seealso [plot_atlas()], [roundAP()]
#' @return A `data.frame` with path information and style information that can be used to plot the atlas plates.
#' @md
#' @export
#'
generate_atlas_data <- function(AP, half = TRUE) {
  stopifnot(is.numeric(AP))
  # find the plate based on AP
  plate <- platereturn(AP)
  # generate the df with the atlas paths (right side only)
  right_plate_df <- generate_plate_df(plate)
  # generate metadata for that plate
  plate_info <- generate_plate_info(plate)

  if (isFALSE(half)) {
    right_plate_df <- add_left_half(right_plate_df)
  }

  # bind with metadata
  right_plate_df <- right_plate_df %>%
    dplyr::left_join(plate_info, by = "path")
  return(right_plate_df)
}

add_left_half <- function(right_plate_df) {
  floor_x <- min(right_plate_df$x)
  left_plate_df <- right_plate_df %>%
    dplyr::group_by(path) %>%
    # mirror individual paths from global floor
    # (we need this because floor_x != 0)
    dplyr::mutate(x = floor_x - x,
                  side = "left") %>%
    dplyr::ungroup() %>%
    # translate from the mirror to the global floor
    dplyr::mutate(x = x + floor_x)
  right_plate_df <- dplyr::bind_rows(right_plate_df,
                                     left_plate_df)
  return(right_plate_df)
}
