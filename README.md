# Replication of Cox et al. (2023)

This repository contains the code for the robustness replication of Cox, C., Bergmann, C., Fowler, E. et al. A systematic review and Bayesian meta-analysis of the acoustic features of infant-directed speech. Nat Hum Behav 7, 114–133 (2023). https://doi.org/10.1038/s41562-022-01452-1
This robustness replication is part of the Institute4Replication (I4R) effort to reproduce and/or replicate articles published in Nature Human Behavior. 


## File structure

### Main Folder
- `original_analysis.qmd` contains the code for the additional analyses. It can also be used to load the data provided by the original authors.
- `robustness_replication.qmd` contains the code for the robustness replication. We perform additional analyses of publication bias, estimating model weights, and MCMC sampler settings. 
- `functions.R` contains auxiliary functions used for reproducibility analyses.

### `/data/`
Contains all raw data used. 

### `/models` 
Contains all original models, and our replications. TODO check if this is too large.


## Citation

Please cite as TODO

## Reproduce
TODO update docker and makefile for final versions

If you have installed Docker and Make, you can use the following files to reproduce the main results within a Docker container:

Run `make docker` from the root directory of this git repository. This will install all necessary
dependencies using the `Dockerfile` and `Makefile`. RStudio Server can then be opened from a browser
(<http://localhost:8787>), and `original_analysis.qmd` and `robustness_replication.qmd` can then be rerun.

