generateSlimScript<-function(msmcInference, outpath, mutationRate, recombinationRate, genomeLength){
msmcInference<-msmcInference %>%
  arrange(desc(generationsAgo)) 


oldestGeneration<-msmcInference$generationsAgo[1]
oldestPopulationSize<-msmcInference$EffectivePopulationSize[1]


initializePopulation<-"1 { sim.addSubpop('p1', <<oldestPopulationSize>>); }"


effectivePopulationSize<-msmcInference$EffectivePopulationSize[-1]


assertthat::are_equal(length(msmcInference$EffectivePopulationSize[-1]),length(abs(diff(msmcInference$generationsAgo))))

forwardInTimeGenerations<-cumsum(abs(diff(msmcInference$generationsAgo)))


assertthat::are_equal(max(forwardInTimeGenerations), oldestGeneration)


slimParameters<-
  tibble(
    generation=forwardInTimeGenerations,
    effectivePopulationSize=effectivePopulationSize
  )

slimParameters$generation=round(slimParameters$generation)
slimParameters$effectivePopulationSize=round(slimParameters$effectivePopulationSize)
oldestPopulationSize=round(oldestPopulationSize)


initializePopulation<-glue::glue(oldestPopulationSize=oldestPopulationSize, initializePopulation, .open = "<<", .close = ">>")


populationSizeChanges<-glue::glue("
 
<<slimParameters$generation>> {p1.setSubpopulationSize(<<slimParameters$effectivePopulationSize>>); }
                                 
                                       ", .open = "<<", .close = ">>")

populationSizeChanges<-glue::collapse(populationSizeChanges)


slimScript<-"

initialize() {
	initializeMutationRate(<<mutationRate>>);
	initializeMutationType('m1', 0.5, 'f', 0.0);
	initializeGenomicElementType('g1', m1, 1.0);
	initializeGenomicElement(g1, 0, <<genomeLength>>);
	initializeRecombinationRate(<<recombinationRate>>);
}

<<initializePopulation>>

<<populationSizeChanges>>

"

slimScript<-glue::glue(slimScript,.open = "<<", .close = ">>")

readr::write_file(slimScript,path=outpath)
}
