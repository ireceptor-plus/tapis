#' a small function to compute CDR3 length and frequence by length
#' @param datatab a dataframe of clonotype
lengthFreq<-function(datatab){
  #compute cdr3dna length
  lengthdf<-datatab@assayData[,.(length=nchar(CDR3dna)),by=c("VpJ", "count","lib")]
  # compute frequency and format dataframe
  lengthDfFormated<-lengthdf %>% group_by(lib) %>% dplyr::count( length) %>%group_by(
    lib)%>%mutate(n=n/sum(n))%>% tidyr::pivot_wider(names_from = length, values_from = n) %>% select(
    lib,order(colnames(.)))%>%mutate_all(~replace(., is.na(.), 0))
  return(lengthDfFormated)
  }