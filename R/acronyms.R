filter_ontology <- function(column, pattern, output){
  # this is the master helper to filter all
  # should be called from map()
  # assumes length(pattern) = 1
  df <- dplyr::filter(ontology, {{column}} == pattern)
  if (nrow(df) > 0) {
    return(dplyr::pull(df, {{output}}))
  } else {
    return(NA)
  }
}

#' @export
acronym_from_id <- function (ids) {
  # re-write from wholebrain::acronym.from.id
  # on low scale its slower but if length(id) is large it has good performance
  result <-
    purrr::map(.x = ids,
               .f = function(tt) filter_ontology(id, tt, acronym))
  result <- sapply(result, as.character)
  return(result)
}


#' @export
id_from_acronym <- function (acronyms) {
  # re-write from wholebrain::id.from.acronym
  # on low scale its slower but if length(id) is large it has good performance
  result <-
    purrr::map(.x = acronyms,
               .f = function(tt) filter_ontology(acronym, tt, id))
  result <- sapply(result, as.numeric)
  return(result)
}

#' @export
get_acronym_parent <- function(acronyms) {
  # re-write from wholebrain::get.acronym.parent
  # on low scale its slower but if length(id) is large it has good performance
  result <-
    purrr::map(.x = acronyms,
               .f = function(tt)
                 # fix root having no parent
                 if (tt == "root") {
                   return (997)
                 } else {
                   return(filter_ontology(acronym, tt, parent))
                 })
  # now get the ids
  result <- sapply(result, acronym_from_id)
  return(result)
}
