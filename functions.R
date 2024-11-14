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


# Compare evidence ratio and random effects -------------------------------
diff_random_effects <- function(fit1, 
                                fit2,
                                ...){
  # Extract point estimates
  pe1 <- bayestestR::point_estimate(fit1, effects = "random")
  pe2 <- bayestestR::point_estimate(fit2, effects = "random")
  
  # Subtract columns Median, Mean, MAP from each other
  df_diff <- data.frame(
    Parameter = pe1$Parameter,
    Median_Diff = pe1$Median - pe2$Median,
    Mean_Diff = pe1$Mean - pe2$Mean,
    MAP_Diff = pe1$MAP - pe2$MAP
  )
  
  return(df_diff)
}


extract_evidence_ratio <- function(filepath, 
                                   hypothesis_string) {
  model <- readRDS(filepath)  
  hypothesis_result <- brms::hypothesis(model, hypothesis_string)  
  return(hypothesis_result$hypothesis$Evid.Ratio)  
}

# Read in replication and original model ----------------------------------

compare_point_ests <- function(original_folder, 
                               replication_folder,
                               random_effects = FALSE,
                               server = TRUE){
  # browser()
  
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
  replication_mods <- gsub("_report.rds", "_report_rep.rds", replication_mods)
  replication_mods <- gsub("models/", "models/replication/", replication_mods)
  
  
  diff_list <- list()
  for (i in seq_along(original_mods_full)){
    diff_list[[i]] <- list()
    original_mod <- readRDS(original_mods_full[i])
    replication_mod <- tryCatch({readRDS(replication_mods[i])}, error = function(e) NA)
    diff_list[[i]]$point_est <- tryCatch({diff_point_est(original_mod, replication_mod)}, error = function(e) NA)
    if(all(!is.na(diff_list[[i]]$point_est))){
      names(diff_list)[i] <- original_mods[i]
    }
    if(isTRUE(random_effects)){
      diff_list[[i]]$random_effect <- tryCatch({diff_random_effects(original_mod, replication_mod)}, error = function(e) NA)
    }
    rm(original_mod)
    rm(replication_mod)
  }
  
  return(diff_list)
}


# Publication Bias Analyses -----------------------------------------------
estimate_robma <- function(prefix,
                           dataset_id = 1,
                           parallel = TRUE,
                           direction = "positive",
                           ...) {
  # read in data
  df_data <- readRDS(here(paste0(
    "data/data_", prefix, "_multiple_final.RData"
  )))
  
  est_pub_bias <- RoBMA::RoBMA(
    y = df_data[[dataset_id]]$Effect_Size,
    se = df_data[[dataset_id]]$Effect_Size_se,
    study_names = df_data[[dataset_id]]$id_site,
    study_ids = df_data[[dataset_id]]$id_site,
    parallel = parallel,
    effect_direction = direction, 
    seed = 35037,
    ...
  )
  return(est_pub_bias)
}



# Model Weights Analyses --------------------------------------------------
load_models <- function(prefix, replication = TRUE) {
  file_names <- c(
    "environment_m_rep.rds",
    "task_m_rep.rds",
    "task_environment_language_age_m_rep.rds",
    "task_language_age_m_rep.rds",
    "environment_language_age_m_rep.rds",
    "age_language_m_rep.rds",
    "age_m_rep.rds",
    "language_m_rep.rds",
    "intercept_m_rep.rds"
  )
  # if original models instead of our replications should be used
  if (isFALSE(replication)) {
    file_names <- gsub("_rep", "", file_names)
  }
  final_names <- c(
    "environment",
    "task",
    "task_environment_language_age",
    "task_language_age",
    "environment_language_age",
    "age_language",
    "age",
    "language",
    "intercept"
  )
  
  models <- list()
  for (i in seq_along(file_names)) {
    if (isTRUE(replication)) {
      model <- readRDS(paste0("models/replication/", prefix, "_", file_names[i]))
    } else{
      model <- readRDS(paste0("models/", prefix, "_", file_names[i]))
    }
    models[[final_names[i]]] <- model
  }
  return(models)
}

# safely compute weights
compute_weights_safe <- function(models, method) {
  tryCatch({
    # unfortunately had to hardcode this, other solutions did not work
    # as intended
    weights <- brms::model_weights(
      models[[1]],
      models[[2]],
      models[[3]],
      models[[4]],
      models[[5]],
      models[[6]],
      models[[7]],
      models[[8]],
      models[[9]],
      weights = method
    )
    names(weights) <- names(models)
    return(weights)
  }, error = function(e) {
    message(paste("Error in model_weights with method", method, ": ", e$message))
    return(NULL)
  })
}

# compute all model weights for a given prefix
compute_model_weights <- function(prefix, pmp = FALSE) {
  models <- load_models(prefix)
  
  weights <- list(
    loo = compute_weights_safe(models, "loo"),
    stacking = compute_weights_safe(models, "stacking"),
    waic = compute_weights_safe(models, "waic"),
    if (isTRUE(pmp)) {
      pmp = tryCatch({
        post_prob(
          models$environment,
          models$task,
          models$task_environment_language_age,
          models$task_language_age,
          models$environment_language_age ,
          models$age_language,
          models$age,
          models$language,
          models$intercept
        )
      }, error = function(e) {
        message(paste("Error in post_prob for prefix", prefix, ": ", e$message))
        return(NULL)
      })
    }
  )
  
  rm(models) # Remove models from memory after calculation
  return(weights)
}
