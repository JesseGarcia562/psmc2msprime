#' Write out VCF of simulated individual
#' 
#' Uses msprime and the reticulate package to write out a VCF to the simulated indidividual
#'
#' @param simulation An <msprime.trees.TreeSequence> object
#' @param outpath The desired output path for the VCF you are trying to create.
#' @param ploidy An integer that defines the ploidy of the individual you simulated. The default is 2, referring to diploid. 
#'
#' @return Returns nothing. But writes a VCF file to the given outpath
#'
#' @examples
#' msmcInference<-readMSMCInference(pathOfMSMCOutFinal = "../data/msprimeMultiHetSep/simulatedMsprime.oak.msmc.out.final.txt", mutationRate = 1e-8)
#' populationParametersChange<-generatePopulationParameterChanges(msmcInference)
#' generateMSPrimeFunction( outPath = "../code/msmc2msprime_Feb1.py", PopulationParametersChangeInput=populationParametersChange)
#' source_python("../code/msmc2msprime_Feb1.py")
#' simulation<-msmc_model(length=3e5, seed=30, mu=1.01e-08)
#' writeVCFOfSimulation(simulation, outpath = "../data/msprimeQLob.vcf", ploidy=2)
#' @export


writeVCFOfSimulation<-function(simulation, outpath, ploidy=2){
  py <- reticulate::import_builtins()
  with(py$open(outpath, "w") %as% file, {
    simulation$write_vcf(file,  ploidy=as.integer(ploidy))
  })
  
  invisibly(outpath)
}
