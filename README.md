# outlineR

This package is a helpful wrapper around functions from mainly the __Momocs__ (Bonhomme et al. 2014), __EBImage__ (Pau et al. 2010), and __imager__ (Barthelme et al. 2020) packages. It is designed for the fast and easy extraction of single outline shapes of, for example, stone tools from images containing multiple thereof, such as the ones present in archaeological publications.


## Installation   

```
remotes::install_github("yesdavid/outlineR")
```

## Workflow

![Raw data as it can be found in archaeological publications. Here: Morar Quartz Industry. Credit: [Wellcome Collection](https://wellcomecollection.org/works/th7egtfj). Attribution 4.0 International (CC BY 4.0)]("./test_data/raw_data/Morar_Quartz_Industry_Wellcome_Collection.jpeg")


![Prepared image (cleaned and thresholded in GIMP).]("./test_data/input_data/Morar_Quartz_Industry_Wellcome_Collection.jpeg")


## Example

```
# Define where the images containing multiple artefacts are right now.
inpath <- "./2_data/raw_data" 

# Define where the separate images should be saved.
outpath <- "./2_data/derived_data" 
```

1. Separate single artefacts/barbs from picture with multiple artefacts/barbs on one image.
```
separate_single_artefacts(inpath = inpath, 
                          outpath = outpath)
```
Afterwards, the JPEGs of the single artefacts should be saved in the folder which you defined under `outpath`. If there is just plain white images in your `outpath` folder, re-check the images you prepared in "inpath" for single outlier pixels or open outlines. If necessary, delete all JPEGS in `outpath`. Then, re-run this command.


2. Use Momocs' function import_jpg() to get the outlines of the images, while at the same time preserving the images name. This function only needs the files in your `output_path_name` folder, so you do not (necesarrily) have to run all of the code above again. If the pathname to a .tps file containing a scaling factor/scaling factors is provided to *tps_file_rescale*, the outlines will get scaled accordingly.
```
single_outlines_list <- get_outlines(outpath = outpath, tps_file_rescale = NULL)
```

3. Combine all outlines into a common file.
```
outlines_combined <- combine_outlines(single_outlines_list = single_outlines_list)
```

4. Inspect your outlines.
```
length(outlines_combined) #how many outlines do you have?
stack(outlines_combined) # shows all outlines above one another(you might want to center and scale them first using Momocs)
Momocs::panel(outlines_combined) # shows all outlines next to each other
Momocs::inspect(outlines_combined) # shows only a single outline at a time. 
```



## References

__Barthelme et al. 2020__: Barthelme, S., Tschumperle, D., Wijffels, J., Assemlal, H. E., & Ochi, S. (2020). imager: Image Processing Library Based on “CImg” (0.42.3) [Computer software]. https://CRAN.R-project.org/package=imager

__Bonhomme et al. 2014__: Bonhomme, V., Picq, S., Gaucherel, C., & Claude, J. (2014). Momocs: Outline Analysis Using R. Journal of Statistical Software, 56(13). https://doi.org/10.18637/jss.v056.i13

__Pau et al. 2010__: Pau, G., Fuchs, F., Sklyar, O., Boutros, M., & Huber, W. (2010). EBImage—An R package for image processing with applications to cellular phenotypes. Bioinformatics, 26(7), 979–981. https://doi.org/10.1093/bioinformatics/btq046





