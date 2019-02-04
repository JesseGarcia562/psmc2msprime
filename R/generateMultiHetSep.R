#' Write out multiHetSep (input of MSMC/PSMC') of simulated individual
#' 
#' Write out multiHetSep (input of MSMC/PSMC') of simulated individual.
#'
#' @param msprimeVCF Path to the msprime generated VCF. 
#' @param outpath Output path for the multiHetSep file that is being generated. 
#'
#' @return Returns nothing. But writes a multihetsep (input to PSMC'/MSMC) file to the given outpath.
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

generateMultiHetSep<-function(msprimeVCFPath, outpath){
  

df<-dplyr::as_tibble(data.table::fread(msprimeVCF))

df<-df %>%
  dplyr::mutate(Homozygous=str_detect(msp_0, "1\\|1")) %>%
  dplyr::mutate(Heterozygous=!Homozygous)

heterozygous<-df %>%
  dplyr::filter(Heterozygous==TRUE)

#Distances between Heterozygous positions. Won't get the end of the chromosome. 
heterozygousDifferences<-diff(c(1,heterozygous$POS))

heterozygous$heterozygousDifferences<-heterozygousDifferences


heterozygous<-heterozygous %>% 
  dplyr::mutate(orderOfAlleles=stringr::str_replace(msp_0, pattern="\\|", replacement = ""))

multihet<-heterozygous %>% 
  dplyr::select(`#CHROM`, POS,heterozygousDifferences, orderOfAlleles ) %>%
  dplyr::mutate(heterozygousDifferences=as.integer(heterozygousDifferences))

readr::write_tsv(x=multihet, path=outpath, col_names = FALSE)

invisible(outpath)
}