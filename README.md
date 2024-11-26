# Replication of Cox et al. (2023)

This repository contains the code for the robustness replication of Cox, C., Bergmann, C., Fowler, E. et al. A systematic review and Bayesian meta-analysis of the acoustic features of infant-directed speech. Nat Hum Behav 7, 114–133 (2023). https://doi.org/10.1038/s41562-022-01452-1
This robustness replication is part of the Institute4Replication (I4R) effort to reproduce and/or replicate articles published in Nature Human Behavior. 



## File Structure

### Main Folder
- `original_analysis.qmd` contains the code for the additional analyses. It can also be used to load the data provided by the original authors.
- `robustness_replication.qmd` contains the code for the robustness replication. We perform additional analyses of publication bias, estimating model weights, and MCMC sampler settings. 
- `functions.R` contains auxiliary functions used for reproducibility analyses.

### `/data/`
Contains all raw data used. As we simply load all data from the original repository, we did not reupload those files here. 

### `/models` 
Contains all original models, and our replications. As these files are too large for GitHub, we uploaded them to associated project on the [Open Science Framework](https://osf.io/ukfrc/) and provide a script (`models/osf_models_download.R`) to download them from the OSF. 
Alternatively, you can re-run our quarto files to obtain all models. 

## Reproducible Environment
We used the `renv` package to create a reproducible package environment. Instructions on how to use `renv` can be found on its [homepage](https://rstudio.github.io/renv/index.html).


## Authors
Björn S. Siepe, Matthias Kloft, Semih Can Aktepe, Björn S. Siepe


