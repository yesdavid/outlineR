#' get_outlines
#'
#' Uses Momocs::import_jpg() to import outline coordinates from the single
#' .jpg files which are either already avaiable, or were created using the
#' separate_single_artefacts_function function. This function preserves the
#' filenames.
#'
#' @param outpath The path to the single .jpg files of the artefacts
#' from which the outlines should be derived (as for example created in the
#' separate_single_artefacts_function function).
#'
#' @param tps_file_rescale (Default = NULL) A dataframe containing at least a column _IMAGE_ and a column _SCALE_.
#' _IMAGE_ contains the names of the images, as they are written in *inpath*.
#' _SCALE_ contains the scaling factor from pixel to a metric measurement.
#' Such a file can be created in i.e. tpsDIG2 (Rohlf 2017).
#'
#' @return Returns a Momocs Out file containing the outlines' coordinates
#' with their associated IDs, derived from the file name.
#'
#' @export
get_outlines <- function(outpath, tps_file_rescale = NULL) {
  artefact_names <- list.files(outpath,
    pattern = ".jpg",
    full.names = F
  )

  outlines <- list()

  pb2 <- utils::txtProgressBar(min = 0, max = length(artefact_names), style = 3)
  for (input_counter in 1:length(artefact_names)) {

    outline_coordinates <- Momocs::import_jpg(file.path(outpath, artefact_names[input_counter]))
    out_file_single_outline <- Momocs::Out(outline_coordinates)

    if (!is.null(tps_file_rescale)) {
      # Rescale coordinates from pixels to real length units
      current_tps_dataset <- subset(tps_file_rescale, IMAGE == strsplit(artefact_names[input_counter], split = "_pseudo")[[1]][1])
      # rescale using rescale factor
      out_file_single_outline <- Momocs::rescale(out_file_single_outline,
                                                 scaling_factor = current_tps_dataset$SCALE)
    }

    names(out_file_single_outline) <- strsplit(artefact_names[input_counter],
                                               split = "[.]")[[1]][1]
    outlines[[gsub("-", "_", strsplit(artefact_names[input_counter],
                                      split = "[.]")[[1]][1])]] <- out_file_single_outline

    utils::setTxtProgressBar(pb2, input_counter)
  }
  close(pb2)

  return(outlines)
}
