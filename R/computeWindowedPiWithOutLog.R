#Row To start at is 0 based. All rows = rowToStartAt=40
computeWindowedPiWithOutLog<-function (msmcOutLog, mutationRate,rowToStartAt=40, totalGenomeLength=8e+06) 
{
  msmcInference <- readMSMCInference(pathOfMSMCOutFinal = msmcOutLog, 
                                     mutationRate = mutationRate)
  rowsToNotInclude <- c(40:1)
  textOfFun <- read_file(system.file("extdata", "skeletonOfMSPrimeFunction.txt", 
                                     package = "psmc2msprime"))
  simulationParameters <- tibble(rowsToNotInclude = rowsToNotInclude, 
  )
  simulationParameters$truncatedMSMCInference <- simulationParameters$rowsToNotInclude %>% 
    map(~msmcInference[(1:.x), ])
  simulationParameters$maximumGeneration <- simulationParameters$truncatedMSMCInference %>% 
    map_dbl(~.x %>% summarise(max = max(generationsAgo)) %>% 
              pull(max))
  simulationParameters$PopulationParametersChange <- simulationParameters$truncatedMSMCInference %>% 
    map(~generatePopulationParameterChanges(.x))
  dir.create("../data/msprimeSimulationScripts")
  simulationParameters <- simulationParameters %>% mutate(outpathOfMsprimeScript = glue("../data/msprimeSimulationScripts/msprime_simulation_{maximumGeneration}.py"))
  

  simulationParameters<- simulationParameters %>%
    filter(rowsToNotInclude == rowToStartAt)

  glue("In this script the oldest generation simulated is {simulationParameters$maximumGeneration}")
  
  testthat::expect_equal(length(simulationParameters$maximumGeneration), 1, info="Too many rows selected, change rowToStartAt (remember it is one indexed)")
  
  map2(.x = simulationParameters$PopulationParametersChange, 
       .y = simulationParameters$outpathOfMsprimeScript, ~generateMSPrimeFunction(textOfFunction = textOfFun, 
                                                                                  outPath = .y, PopulationParametersChangeInput = .x))
  simulationParameters$Pi <- simulationParameters$outpathOfMsprimeScript %>% 
    map(~withScriptGeneratePi(scriptPath = .x, outPath = glue("{.x}.vcf"), 
                                  totalGenomeLength = totalGenomeLength) %>% pull(piPerSite))
  return(simulationParameters)
}