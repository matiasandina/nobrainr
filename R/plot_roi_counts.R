#' @export
plot_roi_counts <- function(count_df, AP, half=TRUE){
  stopifnot(is.numeric(AP))
  stopifnot(is.data.frame(count_df))
  # generate the data using helper functions
  df <- generate_atlas_data(AP, half = half)
  # make sure we only have the plate we are looking for
  count_df <- dplyr::filter(count_df, mm_from_bregma == roundAP(AP)) %>%
    # select the columns we care about
    dplyr::select(value, parent, side)
  if (nrow(count_df) <= 0) {
    usethis::ui_stop("No counts found for AP={AP} in `count_df`")
  }
  # bind with counts
  df <- df %>%
    dplyr::left_join(count_df, by = c("parent", "side"))

  # construct the plot
  base_plot <- ggplot2::ggplot() +
    ggplot2::coord_equal() +
    ggplot2::theme_void()
  # user feedback
  usethis::ui_info("Coloring by `value` in `count_df`")
  # add layers to the plot
  right_plot <-
    base_plot +
    ggplot2::geom_polygon(data = dplyr::filter(df,
                               parent != "root"),
                          ggplot2::aes(x, y,
                     group=interaction(side, path),
                     fill=value), color = "black", lty=2) +
    ggplot2::scale_fill_gradient(low = "white", high="red", na.value = "gray90")

  return(right_plot)

}
