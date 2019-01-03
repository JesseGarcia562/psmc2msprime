computePiPerCallableSites<-function(msprimeVCFPath, windowSize=500000, totalGenomeLength=3000000){
  df<-as_tibble(fread(msprimeVCFPath))
  df<-df %>%
    mutate(Homozygous=str_detect(msp_0, "1\\|1")) %>%
    mutate(Heterozygous=!Homozygous)
  
  heterozygous<-df %>%
    filter(Heterozygous==TRUE)
  
  heterozygous<-heterozygous %>%
    mutate(Bin=cut(POS,breaks=seq(0, totalGenomeLength, by=windowSize), include.lowest = T))
  
  
  simulatePiPerSite<-heterozygous %>% 
    group_by(Bin) %>%
    summarise(piPerSite=n()/windowSize) %>%
    ungroup()
  
  return(simulatePiPerSite)
  
}