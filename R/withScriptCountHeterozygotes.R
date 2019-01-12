withScriptCountHeterozygotes<-function(scriptPath, outPath, totalGenomeLength=3000000, windowSize=500000, seed=30){
  source_python(scriptPath)
  simulation<-msmc_model(length= totalGenomeLength, seed=seed, mu=1.01e-08)
  
  writeVCFOfSimulation(simulation, outpath = outPath, ploidy=2)
  

  computeHeterozygotesPerGenome(msprimeVCF = outPath,windowSize = windowSize, totalGenomeLength=totalGenomeLength)
  
  
}