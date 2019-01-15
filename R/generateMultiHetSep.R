generateMultiHetSep<-function(msprimeVCF, outpath){
  

df<-dplyr::as_tibble(data.table::fread(msprimeVCF))

df<-df %>%
  dplyr::mutate(Homozygous=str_detect(msp_0, "1\\|1")) %>%
  dplyr::mutate(Heterozygous=!Homozygous)

heterozygous<-df %>%
  dplyr::filter(Heterozygous==TRUE)

#Distances between Heterozygous positions. Won't get the end of the chromosome. 
heterozygousDifferences<-diff(c(1,heterozygous$POS))

heterozygous$heterozygousDifferences<-heterozygousDifferences


heterozygous<-heterozygous %>% 
  dplyr::mutate(orderOfAlleles=stringr::str_replace(msp_0, pattern="\\|", replacement = ""))

multihet<-heterozygous %>% 
  dplyr::select(`#CHROM`, POS,heterozygousDifferences, orderOfAlleles ) %>%
  dplyr::mutate(heterozygousDifferences=as.integer(heterozygousDifferences))

readr::write_tsv(x=multihet, path=outpath, col_names = FALSE)

}