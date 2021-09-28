generate_plate_df <- function(plate, AP) {
  # these are the paths that we want to draw
  paths <- EPSatlas$plates[[plate]]@paths
  # get the paths in df format
  right_plate_df <- atlas_to_df(paths, AP = AP)
  right_plate_df <- dplyr::mutate(right_plate_df, side = "right")
  return(right_plate_df)
}

generate_plate_info <- function(plate) {
  # these are the metadata df
  plate_info <-
    EPSatlas$plate.info[[plate]] %>% dplyr::mutate_all(as.character)
  total_paths <-
    glue::glue("path{stringr::str_pad(seq_len(nrow(plate_info)), width = 3, pad=0)}")
  plate_info <- plate_info %>%
    dplyr::mutate(
      # get the ids
      acronym = acronym_from_id(structure_id),
      parent = get_acronym_parent(acronym),
      # keep fiber tracts as fiber tracts
      parent = ifelse(acronym == "fiber tracts", "fiber tracts", parent),
      # create a "path" column to be able to bind with right_plate_df
      path = total_paths
    )
  return(plate_info)
}
