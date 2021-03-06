#' @title Plot Atlas
#' @description This function will plot a desired coronal plate using the desired `AP` level in mm from bregma.
#' @param AP (required) `numeric` AP in mm from bregma. Will be rounded by [roundAP()].
#' @param half `boolean` whether to plot half or full section. Default is TRUE.
#' @param bw `boolean` whether to plot using standard Allen Atlas colors or in black and white. Default is FALSE.
#' @param include_legend `boolean` whether to include legend with the regions. Default is FALSE.
#' @param verbose `boolean` whether to give feedback. Default to TRUE.
#' @seealso [roundAP()]
#' @md
#' @export

plot_atlas <- function(AP, half = TRUE, bw=FALSE, include_legend=FALSE, verbose=TRUE) {
  stopifnot(is.numeric(AP))
  # generate the data using helper functions
  df <- generate_atlas_data(AP, half = half)

  # construct the plot
  base_plot <- ggplot2::ggplot() +
    ggplot2::coord_equal() +
    ggplot2::theme_void()
  # add layers to the plot
  right_plot <-
    base_plot +
    ggplot2::geom_polygon(
      data = dplyr::filter(df,
                           parent == "root"),
      ggplot2::aes(x, y),
      fill = NA, color = "black", lwd = 2
    )
  # plot atlas filling by roi or not
  if (isTRUE(bw)){
    # user feedback
    if (verbose) usethis::ui_info("BW coloring")
    # mutate to gray90 everything except fiber tracts
    df <- df %>% dplyr::mutate(df, style = dplyr::if_else(parent == "fiber tracts",
                                                          style,
                                                          "#fcfcfc"))
    right_plot <-
      right_plot +
      ggplot2::geom_polygon(
        data = dplyr::filter(df,
                             parent != "root"),
        ggplot2::aes(x, y,
                     group = interaction(side, path),
                     fill = style),
        color = "black",
        lty = 3
      ) +
      ggplot2::scale_fill_identity(
        "ROI",
        labels = df$parent,
        breaks = df$style,
        guide = "none"
      )
  } else {
    # user feedback
    if (verbose) usethis::ui_info("Coloring by parent ROI")
    right_plot <-
      right_plot +
      ggplot2::geom_polygon(
        data = dplyr::filter(df,
                             parent != "root"),
        ggplot2::aes(x, y,
                     group = interaction(side, path),
                     fill = style),
        color = "black",
        lty = 3
      ) +
      ggplot2::scale_fill_identity(
        "ROI",
        labels = df$parent,
        breaks = df$style,
        guide = "legend"
      ) +
      ggplot2::guides(fill = ggplot2::guide_legend(override.aes = list(linetype = 0)))
  }

  if (include_legend == FALSE) {
    right_plot <- right_plot + ggplot2::theme(legend.position = "none")
  }

  return(right_plot)
}
