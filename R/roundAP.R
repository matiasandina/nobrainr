#' @export
roundAP <- function (AP, plane = "coronal") {
  if (!plane %in% c("coronal", "sagittal")) {
    stop(sprintf("Plane must be `coronal`` or `sagittal`.\n`%s` was provided",
                 plane))
  }
  atlas_sub <- atlasIndex[atlasIndex$plane == plane, "mm_from_bregma"]
  ind <- sapply(AP, function(x) which.min(abs(x - atlas_sub)))
  vec <- atlas_sub[ind]
  return(vec)
}
