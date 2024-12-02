# Robustness Reproduction of Cox et al. (2023)

This repository contains the code for the robustness reproduction of Cox, C., Bergmann, C., Fowler, E. et al. A systematic review and Bayesian meta-analysis of the acoustic features of infant-directed speech. Nat Hum Behav 7, 114–133 (2023). https://doi.org/10.1038/s41562-022-01452-1
This robustness reproduction is part of the Institute4Replication (I4R) effort to reproduce and/or replicate articles published in Nature Human Behavior. We sometimes use the term "replication", but always refer to out attempt to reproduce and extend the analyses of the original authors. No new data were collected in this project.



## File Structure

### Main Folder

These are the main replication files: 
- `reproduction_analysis.qmd` contains the original analysis code with our small modifications to fix minor errors, as well as an overview of our reproduction efforts.
- `robustness_replication.qmd` contains the code for the robustness replication. We perform additional analyses of estimating model weights and MCMC sampler settings. 
- `robustness_replication_case_study.qmd` contains the code for a case study on simplifying one of the meta-analytic models as described in our manuscript.
- `functions.R` contains auxiliary functions used for reproducibility analyses.

All `.html` files were rendered from the respective `.qmd` files. 

### `/data/`
Contains all raw data used. As we simply load all data from the original repository, we did not re-upload those files here. Instead, data can be downloaded with the code provided by the original authors (contained in `reproduction_analysis.qmd`).

### `/models/` 
Contains all original models, and our replications (in `/models/replication/`). The sub-folder `/models/replication/sampler_check/` contains all models used in the investigation of different sampler settings. 
As these files are too large for GitHub, we uploaded them to associated project on the [Open Science Framework](https://osf.io/ukfrc/) and provide a script (`models/osf_models_download.R`) to download them from the OSF. 
Please note that we had to delete one large model file (`F0_language_m_rep.rds`) to comply with OSF's file size limit. The model can be reproduced by running the code in `reproduction_analysis.qmd`.
Alternatively, you can re-run our quarto files to obtain all models. 

### `/manuscript/`
Contains the reproduction report and the pre-analysis plan.

### `/output/replication`
Contains output files from the robustness replication. 

## Reproducible Environment
We used the `renv` package to create a reproducible package environment. Instructions on how to use `renv` can be found on its [homepage](https://rstudio.github.io/renv/index.html).

## Authors
Björn S. Siepe, Matthias Kloft, Semih Can Aktepe, Björn S. Siepe


