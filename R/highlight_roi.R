highlight_roi <- function(roi_list, AP, half=TRUE, verbose=FALSE){
  stopifnot(is.numeric(AP))
  # generate the data using helper functions
  df <- generate_atlas_data(AP, half = half)
  base_plot <- plot_atlas(AP, half=half, bw = T, verbose=verbose)

  # create key df
  key_df <- data.frame(parent = roi_list,
                       stringsAsFactors = F) %>%
    dplyr::left_join(df, by = c("parent"))
  # TODO: change the style in the new df
  if (nrow(key_df) == length(roi_list)) {
    usethis::ui_info("These are the regions present in your data")
    print(unique(df$parent))
    usethis::ui_stop("No common region in `roi_list` and data.\nYour input was: `{paste(roi_list, collapse=', ')}`")
  }
  # we can now filter complete cases
  key_df <- dplyr::filter(key_df, complete.cases(path))

  if (length(unique(key_df$parent)) < length(roi_list)) {
    usethis::ui_info("Some regions in your data were not found in the requested plate")
    usethis::ui_warn("These are the regions: `{paste(setdiff(roi_list, unique(df$parent)), collapse=', ')}`")
  }

  layer <- ggplot2::geom_polygon(
    data = key_df,
    ggplot2::aes(x, y,
                 group = interaction(side, path),
                 fill = style),
    alpha=0.5
  )
  return(base_plot + layer)
}
