

platereturn <- function (AP) {
  atlas_sub <-
    atlasIndex[atlasIndex$plane == "coronal", "mm_from_bregma"]
  ind <- sapply(AP, function(x)
    which.min(abs(x - atlas_sub)))
  return(ind)
}
