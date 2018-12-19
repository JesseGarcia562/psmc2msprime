computePiPerCallableSites<-function(msprimeVCFPath, windowSize=500000){
  df<-as_tibble(fread("../data/output2.vcf"))
  df<-df %>%
    mutate(Homozygous=str_detect(msp_0, "1\\|1")) %>%
    mutate(Heterozygous=!Homozygous)
  
  heterozygous<-df %>%
    filter(Heterozygous==TRUE)
  
  heterozygous<-heterozygous %>%
    mutate(Bin=cut(POS,breaks=seq(0, 3000000, by=500000), include.lowest = T))
  
  
  simulatePiPerSite<-heterozygous %>% 
    group_by(Bin) %>%
    summarise(piPerSite=n()/500000) %>%
    ungroup()
  
  return(simulatePiPerSite)
  
}