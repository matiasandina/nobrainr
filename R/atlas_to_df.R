atlas_to_df <- function(paths, AP) {
  # set the names of paths so that they are not all equal
  names(paths) <-
    glue::glue("path{stringr::str_pad(seq_len(length(paths)), width = 3, pad=0)}")
  li <- lapply(paths, s4_to_list)
  li <- lapply(li, function(tt)
    lapply(tt, fix_numeric_zero))
  df <- purrr::map_df(li, tibble::as_tibble, .id = "path")
  return(df)
}

s4_to_list <- function(x) {
  if (isS4(x)) {
    nms <- methods::slotNames(x)
    names(nms) <- nms
    # apply recursively
    lapply(lapply(nms, methods::slot, object = x), s4_to_list)
  } else
    x
}

fix_numeric_zero <- function(x) {
  if (identical(x, numeric(0))) {
    return(NA)
  } else {
    return(x)
  }
}
