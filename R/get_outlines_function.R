#' get_outlines
#'
#' Uses Momocs::import_jpg() to import outline coordinates from the single
#' .jpg files which are either already avaiable, or were created using the
#' separate_single_artefacts function. This function preserves the
#' filenames.
#'
#' @param outpath The path to the folder containing the .jpg files of the singled out artefacts
#' from which the outlines should be derived (as for example created in the
#' separate_single_artefacts function).
#'
#' @param tps_file_rescale (Default = NULL) A dataframe containing at least a column _IMAGE_ and a column _SCALE_.
#' This dataframe has to be created first outside this function using the function *tps_to_df* (for more information see ?tps_to_df()).
#' _IMAGE_ contains the names of the images, as they are written in *inpath*.
#' _SCALE_ contains the scaling factor from pixel to a metric measurement.
#' Such a file can be created in i.e. tpsDIG2 (Rohlf 2017).
#'
#' @return Returns a Momocs Out file containing the outlines' coordinates
#' with their associated IDs, derived from the file name.
#'
#'
#' @example
#' \dontrun{
#' get_outlines(outpath = pathname_output, tps_file_rescale = "./test_data/input_data/tps_file.tps")
#'}
#'
#' @export
get_outlines <- function(outpath, tps_file_rescale = NULL) {
  artefact_names <- list.files(outpath,
    pattern = c(".jpg", ".jpeg", ".JPG", ".JPEG"),
    full.names = F
  )

  outlines <- list()

  pb2 <- utils::txtProgressBar(min = 0, max = length(artefact_names), style = 3)
  for (input_counter in 1:length(artefact_names)) {

    outline_coordinates <- Momocs::import_jpg(file.path(outpath, artefact_names[input_counter]))
    out_file_single_outline <- Momocs::Out(outline_coordinates)

    if (!is.null(tps_file_rescale)) {
      tps_file_rescale_df <- tps_file_rescale
      # Rescale coordinates from pixels to real length units
      current_tps_dataset <- subset(tps_file_rescale_df,
                                    tps_file_rescale_df$IMAGE == strsplit(artefact_names[input_counter],
                                                                          split = "_pseudo")[[1]][1])
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
