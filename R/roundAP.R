#' @title Round AP
#' @md
#' @param AP `numeric` AP coordinate in mm from bregma.
#' @param plane `string` must be "coronal" in this version of the package. "Sagittal" not yet supported.
#' @return The rounded `AP` value to the closest plane in the `atlasIndex` dataset.
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
