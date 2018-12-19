readMSMCInference<-function(pathOfMSMCOutFinal, mutationRate){
  msmcOutLog<-readr::read_delim(pathOfMSMCOutFinal, delim="\t", col_names=T)
  
  
  ## Using MSMC formula to convert to output to generations ago and an effective population size. Then, rounding the results for msprime
  msmcInference<- msmcOutLog %>% 
    dplyr::mutate(generationsAgo=left_time_boundary/mutationRate, EffectivePopulationSize= (1/lambda_00)/(2*mutationRate) ) %>%
    dplyr::mutate(generationsAgo=round(generationsAgo), EffectivePopulationSize=round(EffectivePopulationSize))
  
  
  return(msmcInference)
  
  
}
