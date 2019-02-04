#' Write out VCF of simulated individual
#' 
#' Uses msprime and the reticulate package to write out a VCF to the simulated indidividual
#'
#' @param msprimeVCFPath Path to the msprime generated VCF
#' @param windowSize Window size used to compute pi. 
#' @param totalGenomeLength Total genome length simulated. 
#'
#' @return Returns the windowed piPerCallableSites for a simulated individual.
#'
#' @examples
#' msmcInference<-readMSMCInference(pathOfMSMCOutFinal = "../data/msprimeMultiHetSep/simulatedMsprime.oak.msmc.out.final.txt", mutationRate = 1e-8)
#' populationParametersChange<-generatePopulationParameterChanges(msmcInference)
#' generateMSPrimeFunction( outPath = "../code/msmc2msprime_Feb1.py", PopulationParametersChangeInput=populationParametersChange)
#' source_python("../code/msmc2msprime_Feb1.py")
#' simulation<-msmc_model(length=3e5, seed=30, mu=1.01e-08)
#' writeVCFOfSimulation(simulation, outpath = "../data/msprimeQLob.vcf", ploidy=2)
#' generateMultiHetSep(msprimeVCF = "../data/msprimeQLob.vcf",outpath = "../data/msprimeQLob_multihetsep.txt")
#' @export
computePiPerCallableSites<-function(msprimeVCFPath, windowSize=500000, totalGenomeLength){
  df<-tibble::as_tibble(data.table::fread(msprimeVCFPath))
  df<-df %>%
    dplyr::mutate(Homozygous=str_detect(msp_0, "1\\|1")) %>%
    dplyr::mutate(Heterozygous=!Homozygous)
  
  heterozygous<-df %>%
    dplyr::filter(Heterozygous==TRUE)
  
  heterozygous<-heterozygous %>%
    dplyr::mutate(Bin=cut(POS,breaks=seq(0, totalGenomeLength, by=windowSize), include.lowest = T))
  
  
  simulatePiPerSite<-heterozygous %>% 
    dplyr::group_by(Bin) %>%
    dplyr::summarise(piPerSite=n()/windowSize) %>%
    dplyr::ungroup()
  
  return(simulatePiPerSite)
  
}