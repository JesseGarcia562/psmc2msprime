#' Generate the msprime function describing the inferred demography from MSMC
#'
#' Generates the  msprime function describing the inferred demography from MSMC using the populationParameterChanges
#'
#' @param outPath The desired output path for the msprime script you are trying to create.
#' @param PopulationParametersChangeInput The character that defines the how the population sizes change across generations. This is generated by the generatePopulationParameterChanges.
#'
#' @return Returns nothing. But writes to file an msprime function called "msmc_model" that describes the inference made by MSMC
#'
#' @examples
#' msmcInference<-readMSMCInference(pathOfMSMCOutFinal = "../data/msprimeMultiHetSep/simulatedMsprime.oak.msmc.out.final.txt", mutationRate = 1e-8)
#' populationParametersChange<-generatePopulationParameterChanges(msmcInference)
#' generateMSPrimeFunction( outPath = "../code/msmc2msprime_Feb1.py", PopulationParametersChangeInput=populationParametersChange)
#' @export


generateMSPrimeFunction<-function(PopulationParametersChangeInput,outpath){
  textOfFunction<-"
import msprime

def msmc_model(mu=1.5e-8, phi=2e-8, length=1e4, sampleHowManyHaploidGenomes=2, debug=False, seed=30):
    population_configurations = [
        msprime.PopulationConfiguration(
            sample_size=sampleHowManyHaploidGenomes)
    ]
    demographic_events = [

{PopulationParametersChange}

		]
    
    if debug:
        # Use the demography debugger to print out the demographic history
        # that we have just described.
        dd = msprime.DemographyDebugger(
            population_configurations=population_configurations,
            demographic_events=demographic_events)
        dd.print_history()
    else:
        sim = msprime.simulate(population_configurations=population_configurations,
                               demographic_events=demographic_events,
                               mutation_rate=mu, 
                               recombination_rate=phi, 
                               length=length,
                               random_seed=seed)
        return sim
"



  fn<-glue::glue(textOfFunction, PopulationParametersChange= PopulationParametersChangeInput)
  readr::write_file(fn,path=outpath)
#Return outpath invisibly for use in tidy pipe
  invisible(outpath)
}
