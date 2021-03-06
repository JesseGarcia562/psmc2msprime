#' Generate the population parameter changes for msprime.
#'
#' Uses msmcInference tibble to generate the population parameter changes for a msprime function. 
#'
#' @param msmcInference The tibble that readMSMCInference generates. 
#'
#' @return A character that desribes the population parameter changes msprime will simulate. Based entirely off the msmcInference. 
#'
#' @examples
#' msmcInference<-readMSMCInference(pathOfMSMCOutFinal = "../data/msprimeMultiHetSep/simulatedMsprime.oak.msmc.out.final.txt", mutationRate = 1e-8)
#' populationParametersChange<-generatePopulationParameterChanges(msmcInference)
#' @export


generatePopulationParameterChanges<-function(msmcInference){

populationParameterChanges<-glue::glue("
 
\t\t\t\tmsprime.PopulationParametersChange(time={msmcInference$generationsAgo}, initial_size={msmcInference$EffectivePopulationSize}, growth_rate=0),
                                 
                                       ")


## Population parameters need to be given as a python list. 
## Therefore, there needs to be a "," seperator for each population Parameter. Can use "paste" and set sep 
## But then we'd need it all to be in one vector. 
howManyPopulationParamterChanges<-sum(stringr::str_count(populationParameterChanges,"msprime.PopulationParametersChange"))

#glue also contains the number of vectors
testthat::expect_equal(howManyPopulationParamterChanges, length(populationParameterChanges))


##The last populationParameterChange can not contain a ","
populationParameterChanges[howManyPopulationParamterChanges] <- stringr::str_replace(populationParameterChanges[howManyPopulationParamterChanges], pattern = "\\),", replacement = "\\)" )

populationParameterChanges<-paste0(populationParameterChanges, collapse = "\n")

return(populationParameterChanges)
}



