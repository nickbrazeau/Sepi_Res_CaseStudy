
vcfR2snpeff_ann <- function(vcfRobj){
  ann <- tibble::as_tibble(vcfR::getFIX(vcfRobj, getINFO = T)) %>%
    dplyr::select(CHROM, POS, REF, ALT, INFO)

  snpeff <- stringr::str_split(ann$INFO, ";", simplify = T)
  ann <- cbind.data.frame(ann, snpeff) %>%
    tidyr::gather(., key="temp", value="infovalues", 6:ncol(.)) %>%
    dplyr::select(CHROM, POS, REF, ALT, infovalues)

  snpeff <- stringr::str_split(ann$infovalues, "=", simplify = T)
  colnames(snpeff) <- c("param", "value")
  ann <- cbind.data.frame(ann, snpeff)

  ann <- ann[grepl("SNPEFF", ann$param), ]

  ann <- ann %>%
    dplyr::select(-c(infovalues)) %>%
    tidyr::spread(., key="param", value="value") %>%
    dplyr::mutate(POS = as.numeric(POS)) %>%
    dplyr::arrange(POS)

  return(ann)
}


callable_loci <- function(vcfRobj, thrshld = 0.8){

  gt <- vcfR::extract.gt(vcfRobj, element = "GT", as.numeric = T)
  thrshld <- apply(gt, 1, function(x){mean(!is.na(x))}) >= thrshld

  # new vcfR
  vcfRobj@gt <- vcfRobj@gt[thrshld,]

  fix <- as.matrix(vcfR::getFIX(vcfRobj, getINFO = T)[thrshld,])
  gt <- as.matrix(vcfRobj@gt)
  meta <- append(vcfRobj@meta, paste("##Dropped loci with missingness of greater than (rowmeans):", thrshld))

  # Setting class based off of vcfR documentation https://github.com/knausb/vcfR/blob/master/R/AllClass.R
  newvcfR <- new("vcfR", meta = meta, fix = fix, gt = gt)

  return(newvcfR)


}



