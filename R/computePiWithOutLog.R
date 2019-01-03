## Needs to be input



msmcOutLog="../data/msmcDemographies/20/qlobataBootstrap20Iterations.tsv"
mutationRate=1.01e-08



computePiWithOutLog<-function(msmcOutLog, mutationRate) {
msmcInference<-readMSMCInference(pathOfMSMCOutFinal = msmcOutLog, mutationRate = mutationRate)



rowsToNotInclude<-c(40:1)
textOfFun<-read_file(system.file("extdata", "skeletonOfMSPrimeFunction.txt",package = "psmc2msprime"))
simulationParameters<-
  tibble(
    rowsToNotInclude=rowsToNotInclude,
  )
simulationParameters$truncatedMSMCInference<-simulationParameters$rowsToNotInclude %>%
  map(~msmcInference[(1:.x),])


simulationParameters$maximumGeneration<-simulationParameters$truncatedMSMCInference %>%
  map_dbl(~.x %>% summarise(max=max(generationsAgo) ) %>% pull(max) )


simulationParameters$PopulationParametersChange<-simulationParameters$truncatedMSMCInference %>%
  map(~generatePopulationParameterChanges(.x))

dir.create("../data/msprimeSimulationScripts")

simulationParameters<-simulationParameters %>%
  mutate(outpathOfMsprimeScript=glue("../data/msprimeSimulationScripts/msprime_simulation_{maximumGeneration}.py")) 

map2(.x=simulationParameters$PopulationParametersChange, .y=simulationParameters$outpathOfMsprimeScript, ~ generateMSPrimeFunction(textOfFunction = textOfFun,
                                                                                                                                   outPath = .y, 
                                                                                                                                   PopulationParametersChangeInput=.x))





simulationParameters$Pi<-simulationParameters$outpathOfMsprimeScript %>% 
  map_dbl( ~ withScriptGeneratePi(scriptPath=.x, outPath=glue("{.x}.vcf"), length=1e6)  %>% pull(piPerSite) %>% mean() ) 

return(simulationParameters)
}


