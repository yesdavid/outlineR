#' separate_single_artefacts
#'
#' A function to separate single artefacts from an image containing
#' multiple artefacts.
#'
#' @param inpath Pathname to the folder containing the JPEG
#' images with multiple artefacts on it.
#' @param outpath Pathname to the folder where the JPEGs of
#' the singled-out artefacts from this function should be stored.
#'
  #' @return If return_combined_outlines = TRUE, returns the combined
#' Coo objects in a single Opn file. If return_combined_outlines = FALSE,
#' returns a list of coordinate matrices of each open outline.
#'
#' @export
separate_single_artefacts <- function(inpath, outpath) {

  files_to_use_names <- list.files(inpath,
                                   full.names = FALSE,
                                   pattern = c(".jpg", ".jpeg", ".JPG", ".JPEG"))
  inpath <- list.files(inpath,
                       full.names = TRUE,
                       pattern = c(".jpg", ".jpeg", ".JPG", ".JPEG"))

  pb <- utils::txtProgressBar(min = 0, max = length(inpath), style = 3)
  for (current_masked_file in 1:length(inpath)) {
    x_raw <- imager::load.image(inpath[current_masked_file])

    x_grayscale <- imager::grayscale(x_raw)

    # because some images had to be pre-processed in GIMP with the thresholding tool, this step might result in errors
    x_threshold <- x_grayscale
    try(x_threshold <- imager::threshold(x_threshold),
        silent = TRUE)
    x_clean <- imager::clean(x_threshold, 10)
    x_clean_cimg <- imager::as.cimg(x_clean)

    x_clean_img <- EBImage::Image(x_clean_cimg)
    x_clean_img_filled <- EBImage::fillHull(1 - x_clean_img)

    bin_image <- round(x_clean_img_filled / max(x_clean_img_filled), 0)

    bin_image_labeled <- EBImage::bwlabel(bin_image)

    # important step to be able to work with images that are already binary and images that are still in grayscale
    if (EBImage::numberOfFrames(bin_image_labeled) == 1) {
      bin_image_labeled_filled_frame <- try(EBImage::getFrame(bin_image_labeled, 1),
        silent = TRUE
      )
    } else {
      bin_image_labeled_filled_frame <- try(EBImage::getFrame(bin_image_labeled, 3),
        silent = TRUE
      )
    }

    features <- EBImage::computeFeatures.shape(bin_image_labeled_filled_frame)

    all_objects <- 1:max(bin_image_labeled_filled_frame)

    for (object_counter in all_objects) {

      # single out individual artefacts (starting with the largest)
      current_object <- EBImage::rmObjects(
        bin_image_labeled_filled_frame,
        all_objects[all_objects != object_counter]
      )

      # inverts the image (black artefact on white background)
      current_object_inverted <- 1 - current_object

      # save it as .jpg with a pseudo-number (does not represent the number which the artefact might have on the page)
      EBImage::writeImage(
        current_object_inverted,
        file.path(outpath,
                  paste0(strsplit(files_to_use_names[current_masked_file], split = "[.]")[[1]][1],
                         "_pseudo_no_",
                         object_counter,
                         ".jpg"))
      )
    }

    gc()
    utils::setTxtProgressBar(pb, current_masked_file)
  }
  close(pb)
}
