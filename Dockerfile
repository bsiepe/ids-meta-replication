## set R version (https://hub.docker.com/r/rocker/verse/tags)
FROM rocker/verse:4.4.1

## set up directories
RUN mkdir /home/rstudio/data /home/rstudio/models /home/rstudio/output 
COPY ids-meta-replication.Rproj /home/rstudio/
COPY functions.R /home/rstudio/

## install R packages from CRAN the last day of the specified R version
## ncpus set to -1 (all available cores)
RUN install2.r --error --skipinstalled --ncpus -1 \
    bayestestR boot brms clickR Counterfactual cowplot dplyr effectsize esc forcats ggalluvial ggplot2 ggridges glue here job knitr lattice lme4 loo metafor mice moments osfr pacman pander PublicationBias RColorBrewer Rcpp readxl robumeta tidybayes tidyverse rmarkdown bayesplot RoBMA

