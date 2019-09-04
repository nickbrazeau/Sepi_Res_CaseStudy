library(Biostrings)

#.........................
# ResFinder Table
#.........................
resfinderdb <- list.files(path = "~/Documents/MountPoints/mountIDEEL/resources/BacterialDatabases_CGE/resfinder/",
                          pattern = ".fsa", full.names = T)

readresfinder <- function(path){
  abx <- basename(path)
  abx <- gsub(".fsa", "", abx)
  fa <- Biostrings::readDNAStringSet(path)
  ret <- data.frame(abx = abx,
                    gene = names(fa))
  return(ret)

}

resfinderdb.genesdf <- lapply(resfinderdb, readresfinder) %>%
  dplyr::bind_rows()

saveRDS(resfinderdb.genesdf, file = "data/derived_data/resfinderdb_genesdf.rds")


