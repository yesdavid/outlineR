#' get_outlines
#'
#' Uses Momocs::import_jpg1() to import outline coordinates from the single
#' .jpg files which are either already avaiable, or were created using the
#' separate_single_artefacts_function function. This function preserves the
#' filenames.
#'
#' @param pathname_output The path to the single .jpg files of the artefacts
#' from which the outlines should be derived (as for example created in the
#' separate_single_artefacts_function function).
#'
#' @return Returns a Momocs Out file containing the outlines' coordinates
#' with their associated IDs, derived from the file name.
#'
#' @export
get_outlines <- function(pathname_output) {
  artefact_names <- list.files(pathname_output,
    pattern = ".jpg",
    full.names = F
  )

  outlines <- list()

  pb2 <- utils::txtProgressBar(min = 0, max = length(artefact_names), style = 3)
  for (input_counter in 1:length(artefact_names)) {

    outline_coordinates <- Momocs::import_jpg(file.path(pathname_output, artefact_names[input_counter]))
    out_file_single_outline <- Momocs::Out(outline_coordinates)

    # Rescale coordinates from pixels to real length units
    # current_tps_dataset <- subset(tps_file_regex, IMAGE == artefact_names[input_counter])
    ## rescale using rescale factor
    # out_file_single_outline <- Momocs::rescale(out_file_single_outline,
    #                                            scaling_factor = current_tps_dataset$SCALE)

    names(out_file_single_outline) <- strsplit(artefact_names[input_counter],
                                               split = "[.]")[[1]][1]
    outlines[[gsub("-", "_", strsplit(artefact_names[input_counter],
                                      split = "[.]")[[1]][1])]] <- out_file_single_outline

    utils::setTxtProgressBar(pb2, input_counter)
  }
  close(pb2)

  return(outlines)
}
