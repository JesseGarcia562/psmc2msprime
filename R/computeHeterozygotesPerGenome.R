computeHeterozygotesPerGenome<-function(msprimeVCFPath, windowSize=500000, totalGenomeLength=3000000){
  df<-as_tibble(fread(msprimeVCFPath))
  df<-df %>%
    mutate(Homozygous=str_detect(msp_0, "1\\|1")) %>%
    mutate(Heterozygous=!Homozygous)
  
  numberOfHeterozygotes<-df %>%
    filter(Heterozygous==TRUE) %>%
    nrow()

  
  return(numberOfHeterozygotes)
  
}