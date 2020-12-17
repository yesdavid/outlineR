#' Uses Momocs::import_jpg1() to import outline coordinates from the single .jpg files which are either already avaiable, or were created using the separate_single_artefacts_function function. This function preserves the filenames.
#' @param pathname_output The path to the single .jpg files of the artefacts from which the outlines should be derived (as for example created in the separate_single_artefacts_function function).
#' @return Returns a Momocs Out file containing the outlines' coordinates with their associated IDs, derived from the file name.



get_outlines_function <- function(pathname_output){

  artefact_names <- list.files(pathname_output,
                                     pattern = ".jpg",
                                     full.names = F)

  outlines <- list()

  pb2 <- txtProgressBar(min = 0, max = length(artefact_names), style = 3)
  for (input_counter in 1:length(artefact_names)){

    # per Momocs werden die outlines eines jpgs geladen
    outline_coordinates <- Momocs::import_jpg1(paste0(pathname_output, artefact_names[input_counter]))
    out_file_single_outline <- Momocs::Out(outline_coordinates) # In Momocs, Out-classes objects are lists of closed outlines, with optional components, and on which generic methods such as plotting methods (e.g. stack) and specific methods (e.g. efourier can be applied. Out objects are primarily Coo objects.
    # Momocs::inspect(out_file_single_outline)

    # Rescale coordinates from pixels to real length units
    # current_tps_dataset <- subset(tps_file_regex, IMAGE == artefact_names[input_counter])

    ## rescale using rescale factor
    # out_file_single_outline_rescaled <- Momocs::rescale(out_file_single_outline,
    #                                  scaling_factor = current_tps_dataset$SCALE)
    # names(out_file_single_outline_rescaled) <- strsplit(artefact_names[input_counter], split ='[.]')[[1]][1]
    # Momocs::inspect(out_file_single_outline_rescaled)

    # outlines[[gsub("-", "_",  strsplit(artefact_names[input_counter], split ='[.]')[[1]][1])]] <- out_file_single_outline_rescaled

    names(out_file_single_outline) <- strsplit(artefact_names[input_counter], split ='[.]')[[1]][1]
    outlines[[gsub("-", "_",  strsplit(artefact_names[input_counter], split ='[.]')[[1]][1])]] <- out_file_single_outline

    setTxtProgressBar(pb2, input_counter)

  }
  close(pb2)

  return(outlines)
}
