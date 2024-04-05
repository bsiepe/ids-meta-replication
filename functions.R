
# Auxiliary Functions for IDS-Meta-Replication ----------------------------

# Compare Point Estimates of BRMS objects ---------------------------------
diff_point_est <- function(fit1, 
                              fit2,
                              ...){    # to be passed to bayestestR
  # Extract point estimates
  pe1 <- bayestestR::point_estimate(fit1, ...)
  pe2 <- bayestestR::point_estimate(fit2, ...)
  
  # Subtract columns Median, Mean, MAP from each other
  df_diff <- data.frame(
    Parameter = pe1$Parameter,
    Median_Diff = pe1$Median - pe2$Median,
    Mean_Diff = pe1$Mean - pe2$Mean,
    MAP_Diff = pe1$MAP - pe2$MAP
  )
  
  return(df_diff)
  
}



# Read in replication and original model ----------------------------------

compare_point_ests <- function(original_folder, 
                               replication_folder,
                               server = TRUE){
  original_mods_full <- list.files(original_folder, pattern = ".rds", full.names = TRUE)
  # Exclude nonimputed and prior predictive files
  original_mods_full <- original_mods_full[!grepl("nonimputed", original_mods_full)]
  original_mods_full <- original_mods_full[!grepl("prior", original_mods_full)]
  original_mods <- gsub(".rds", "", original_mods_full)
  original_mods <- gsub(paste0(original_folder,"/"), "", original_mods_full)
  
  if(isTRUE(server)){
    original_mods_full <- paste0("~/ids-meta-replication/", original_mods_full)
  }
  
  
  replication_mods <- gsub("_m.rds", "_m_rep.rds", original_mods_full)
  replication_mods <- gsub("models/", "models/replication/", replication_mods)
  
  
  diff_list <- list()
  for (i in seq_along(original_mods_full)){
    original_mod <- readRDS(original_mods_full[i])
    replication_mod <- tryCatch({readRDS(replication_mods[i])}, error = function(e) NA)
    diff_list[[i]] <- tryCatch({diff_point_est(original_mod, replication_mod)}, error = function(e) NA)
    names(diff_list)[i] <- original_mods[i]
    rm(original_mod)
    rm(replication_mod)
  }
  
  return(diff_list)
}


