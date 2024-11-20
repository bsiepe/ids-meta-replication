# Script to download OSF models -------------------------------------------
library(osfr)
proj <- osf_retrieve_node("ukfrc")

target_dir <- osf_ls_files(proj, path = "models", pattern = "replication")

# Download the files
osf_download(target_dir, "models/", conflicts = "overwrite")

# Check how many files there are
replication_files <- proj |> 
  osf_ls_files(path = "models/replication", type = "file",
               n_max = Inf) |> 
  pull(name)



# Alternatively, you can also download them manually and then check
# if all files were downloaded correctly
n_files <- list.files("models/replication") |> 
  length()

if(n_files == length(replication_files)){
  message("All files were downloaded correctly")
} else {
  message("Some files were not downloaded correctly")
}