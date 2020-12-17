#' A function containing a recursive loop to combine a list of single outline coordinate-sets into a single Momocs::Out/Opn file
#'
#' @param single_outlines_list A list containing separate coordinate matrices (Momocs' Coo objects) as for example created with the "separate_single_artefacts_function" function.
#'
#' @return Returns the combined Coo objects in a single Out/Opn file
#'
#' @export
combine_outlines_function <- function(single_outlines_list) {
  outlines_combined <- Momocs::combine(single_outlines_list[[1]], single_outlines_list[[2]])

  for (outlines_index in 3:length(single_outlines_list)) {
    outlines_combined <- Momocs::combine(outlines_combined, single_outlines_list[[outlines_index]])
  }

  return(outlines_combined)
}
