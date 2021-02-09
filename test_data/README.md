
# ./raw_data

**Morar_Quartz_Industry_Wellcome_Collection.jpeg**
 
Morar_Quartz_Industry_Wellcome_Collection.jpeg is a raw example image (here: Morar Quartz Industry) as it can be found in many archaeological publications. Credit: 
Wellcome Collection (https://wellcomecollection.org/works/th7egtfj, distributed under CC BY 4.0).


# ./input_data

**Morar_Quartz_Industry_Wellcome_Collection_clean.jpeg**

Morar_Quartz_Industry_Wellcome_Collection_clean.jpeg is the raw "./raw_data/Morar_Quartz_Industry_Wellcome_Collection.jpeg" image (distributed by [Wellcome Collection](https://wellcomecollection.org/works/th7egtfj) under CC BY 4.0) manually prepared in an image manipulation software. Numberings, descriptions, etc. (everything that is not an artefact) were removed by hand. The image was thresholed/binarized in GIMP2 under "_Colors_" -> "_Thresholding..._".


**tps_file.tps**

tps_file.tps is a .tps file containing "LM", "IMAGE", "ID", and "SCALE" information (no more no less) for the "./input_data/Morar_Quartz_Industry_Wellcome_Collection_clean.jpeg" image (originally distributed by [Wellcome Collection](https://wellcomecollection.org/works/th7egtfj) under CC BY 4.0) and was created using tpsUtil and tpsDig2 ([Rohlf 2017](http://www.sbmorphometrics.org/)). It can be used to scale the outlines accordingly.




# ./derived_data

This folder contains the singled out artefacts from the "./input_data/Morar_Quartz_Industry_Wellcome_Collection_clean.jpeg" image (originally distributed by [Wellcome Collection](https://wellcomecollection.org/works/th7egtfj) under CC BY 4.0). These artefacts were singled out using the outlineR::separate_single_artefacts() function and can be fed into the outlineR::get_outlines() function.
