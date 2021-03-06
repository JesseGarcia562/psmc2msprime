% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/computePiPerCallableSites.R
\name{computePiPerCallableSites}
\alias{computePiPerCallableSites}
\title{Write out VCF of simulated individual}
\usage{
computePiPerCallableSites(msprimeVCFPath, windowSize = 5e+05,
  totalGenomeLength)
}
\arguments{
\item{msprimeVCFPath}{Path to the msprime generated VCF}

\item{windowSize}{Window size used to compute pi.}

\item{totalGenomeLength}{Total genome length simulated.}
}
\value{
Returns the windowed piPerCallableSites for a simulated individual.
}
\description{
Uses msprime and the reticulate package to write out a VCF to the simulated indidividual
}
\examples{
msmcInference<-readMSMCInference(pathOfMSMCOutFinal = "../data/msprimeMultiHetSep/simulatedMsprime.oak.msmc.out.final.txt", mutationRate = 1e-8)
populationParametersChange<-generatePopulationParameterChanges(msmcInference)
generateMSPrimeFunction( outPath = "../code/msmc2msprime_Feb1.py", PopulationParametersChangeInput=populationParametersChange)
source_python("../code/msmc2msprime_Feb1.py")
simulation<-msmc_model(length=3e5, seed=30, mu=1.01e-08)
writeVCFOfSimulation(simulation, outpath = "../data/msprimeQLob.vcf", ploidy=2)
generateMultiHetSep(msprimeVCF = "../data/msprimeQLob.vcf",outpath = "../data/msprimeQLob_multihetsep.txt")
}
