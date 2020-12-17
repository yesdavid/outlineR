#' A function to create open outlines from closed outlines. The way it is implemented, the open outline will start at the highest, left-most coordinate, run clock-wise, and will end at the lowest, left-most coordinate.
#'
#' @param single_outlines_list A Momocs Out file containing closed outlines.
#' @param return_combined_outlines (default = TRUE) A logical parameter stating wether to output a Momocs Opn-file, or a list of coordinate matrices of each open outline.
#' @return If return_combined_outlines = TRUE, returns the combined Coo objects in a single Opn file. If return_combined_outlines = FALSE, returns a list of coordinate matrices of each open outline.
#' @examples
#' separate_single_artefacts_function(pathname_input = "path/to/input_files", pathname_output = "path/to/output_files")



separate_single_artefacts_function <- function(pathname_input, pathname_output){

  pathname_input <- list.files(pathname_input, full.names = TRUE)
  files_to_use_names <- list.files(pathname_input, full.names = FALSE)


  pb <- txtProgressBar(min = 0, max = length(pathname_input), style = 3)
  for (current_masked_file in 1:length(pathname_input)){

    x_raw <- imager::load.image(pathname_input[current_masked_file])

    # plot(x_raw)

    x_grayscale <- grayscale(x_raw)
    # plot(x_grayscale)

    # x_binary <- round(x_grayscale/max(x_grayscale),0)
    # plot(x_binary)

    # because some images had to be pre-processed in GIMP with the thresholding tool, this step might result in errors
    thresholding_error <- testit::has_error(imager::threshold(x_grayscale),
                                            silent = T)
    if (thresholding_error == FALSE){
      x_threshold <- imager::threshold(x_grayscale)
    } else {
      x_threshold <- x_grayscale
    }

    x_clean <- imager::clean(x_threshold, 10)
    # plot(x_clean)


    x_clean_cimg <- imager::as.cimg(x_clean)
    x_clean_img <- EBImage::Image(x_clean_cimg)
    # EBImage::display(x_clean_img,
    #                  method = "raster",
    #                  all = T)

    x_clean_img_filled <- EBImage::fillHull(1-x_clean_img)
    # EBImage::display(x_clean_img_filled,
    #                  method = "raster",
    #                  all = T)


    bin_image <- round(x_clean_img_filled/max(x_clean_img_filled),0)

    bin_image_labeled <- EBImage::bwlabel(bin_image)

    # EBImage::display(bin_image_labeled,
    #                  method = "raster",
    #                  all = T)


    # important step to be able to work with images that are already binary and images that are still in grayscale
    if (EBImage::numberOfFrames(bin_image_labeled) == 1){

      bin_image_labeled_filled_frame <- try(EBImage::getFrame(bin_image_labeled, 1),
                                            silent = TRUE)

    } else {
      bin_image_labeled_filled_frame <- try(EBImage::getFrame(bin_image_labeled, 3),
                                            silent = TRUE)
    }

    # EBImage::computeFeatures.shape(bin_image_labeled_filled_frame) %>% EBImage::display(method = "raster", all = T)

    features <- EBImage::computeFeatures.shape(bin_image_labeled_filled_frame)


    all_objects <- 1:max(bin_image_labeled_filled_frame)

    for (object_counter in all_objects){

      # freistellen der einzelnen artefakte (bisher nur des groessten artefakts)
      current_object <- EBImage::rmObjects(bin_image_labeled_filled_frame,
                                           all_objects[all_objects!=object_counter])
      # EBImage::display(current_object,
      #                  method="raster",
      #                  interpolate=F)

      current_object_inverted <- 1-current_object
      # invertieren - sodass das artefakt schwarz auf weissem hintergrund ist - und als jpg speichern
      EBImage::writeImage(current_object_inverted,
                          paste0(pathname_output, strsplit(files_to_use_names[current_masked_file], split = "[.]")[[1]][1], "_pseudo_no_", object_counter, ".jpg"))

    }

    gc()
    setTxtProgressBar(pb, current_masked_file)
  }
  close(pb)



}
