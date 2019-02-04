#' Simulates a given msprime function in msprime
#'
#' given a function that defines the simulation of a population in msprime, this funtion executes the function and returns the resulting msprime.trees.TreeSequence
#'
#' @param msprimeFunctionPath The path to the python (.py) function that defines an msprime model. 
#' @param mutationRate The mutation rate in mutations/bp/gen. This is the same mutation rate that one would use to scale results to real time and population sizes. See https://github.com/stschiff/msmc/blob/master/guide.md for more help.
#' @param phi The recombination rate in recombinations/bp/gen.
#' @param length The total amount of sequence to simulate. 
#' @param sampleHowManyHaploidGeneomes The number of haploid genomes in the output. For PSMC' you need 1 diploid indidividual. Therefore, you'd need to sample 2 haploid genomes. I don't know what happens when this number is not 2. 
#' @param debug If True this parameter evokes msprime's demography debugger.
#' @param seed formsprime simulation. 
#' @return msprime.trees.TreeSequence
#' @examples
#' readMSMCInference(pathOfMSMCOutFinal = "../data/msprimeMultiHetSep/simulatedMsprime.oak.msmc.out.final.txt", mutationRate = 1e-8)
#' simulation<-simulateInMSPrime(msprimeFunctionPath = "../code/msmc2msprime_Feb1.py")
#' @export


simulateInMSPrime<-function(msprimeFunctionPath, mutationRate=1.5e-8, phi=2e-8, length=1e4, sampleHowManyHaploidGenomes=2, debug=FALSE, seed=30){
source_python(msprimeFunctionPath)
simulation<-msmc_model(mu=mutationRate, phi=phi, length=as.integer(length), sampleHowManyHaploidGenomes=as.integer(sampleHowManyHaploidGenomes), debug=debug, seed=as.integer(seed))
return(simulation)
}