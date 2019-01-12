#Row To start at is 0 based. All rows = rowToStartAt=40
computeNumberOfHeterozygotesWithOutLog<-function (msmcOutLog, mutationRate,rowToStartAt=40, totalGenomeLength=8e+06, seed=30) 
{
  #browser()
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
  simulationParameters <- simulationParameters %>% mutate(outpathOfMsprimeScript = glue("../data/msprimeSimulationScripts/msprime_simulation_{maximumGeneration}_{seed}.py"))
  

  simulationParameters<- simulationParameters %>%
    filter(rowsToNotInclude == rowToStartAt)

  glue("In this script the oldest generation simulated is {simulationParameters$maximumGeneration}")
  
  testthat::expect_equal(length(simulationParameters$maximumGeneration), 1, info="Too many rows selected, change rowToStartAt (remember it is one indexed)")
  
  map2(.x = simulationParameters$PopulationParametersChange, 
       .y = simulationParameters$outpathOfMsprimeScript, ~generateMSPrimeFunction(textOfFunction = textOfFun, 
                                                                                  outPath = .y, PopulationParametersChangeInput = .x))
  simulationParameters$numberOfHeterozygotes <- simulationParameters$outpathOfMsprimeScript %>% 
    map_dbl(~withScriptCountHeterozygotes(scriptPath = .x, outPath = glue("{.x}_seed{seed}.vcf"), 
                                  totalGenomeLength = totalGenomeLength, seed=seed) )


  simulationParameters$seed=seed
  simulationParameters$totalGenomeLength=totalGenomeLength
  simulationParameters$msmcOutLog=msmcOutLog
  return(simulationParameters)
}