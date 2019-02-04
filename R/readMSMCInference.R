#' Read in the final ouput of MSMC.
#'
#' Reads in the out.final.txt file from MSMC and converts the output into a tibble. 
#'
#' @param pathOfMSMCOutFinal The path to the "out.final.txt" that MSMC outputs. 
#' @param mutationRate The mutation rate in mutations/bp/gen. This is the same mutation rate that one would use to scale results to real time and population sizes. See https://github.com/stschiff/msmc/blob/master/guide.md for more help.
#'
#' @return A tibble desribing the scaled population size changes over generations.
#'
#' @examples
#' readMSMCInference(pathOfMSMCOutFinal = "../data/msprimeMultiHetSep/simulatedMsprime.oak.msmc.out.final.txt", mutationRate = 1e-8)
#'
#' @export


readMSMCInference<-function(pathOfMSMCOutFinal, mutationRate){
  msmcOutLog<-readr::read_delim(pathOfMSMCOutFinal, delim="\t", col_names=T)
  testthat::expect_named(msmcOutLog,  c('time_index', 'left_time_boundary', 'right_time_boundary', 'lambda_00'), info="Data is not formatted as an MSMC out.final.txt file")

  
  ## Using MSMC formula to convert output to "generations ago" and a "effective population size." Then, rounding the results for msprime
  msmcInference<- msmcOutLog %>% 
    dplyr::mutate(generationsAgo=left_time_boundary/mutationRate, EffectivePopulationSize= (1/lambda_00)/(2*mutationRate) ) %>%
    dplyr::mutate(generationsAgo=round(generationsAgo), EffectivePopulationSize=round(EffectivePopulationSize))
  
  
  return(msmcInference)
  
  
}
