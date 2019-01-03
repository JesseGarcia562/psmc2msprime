withScriptGeneratePi<-function(scriptPath, outPath, totalGenomeLength=3000000, windowSize=500000){
  source_python(scriptPath)
  simulation<-msmc_model(length= totalGenomeLength, seed=30, mu=1.01e-08)
  
  writeVCFOfSimulation(simulation, outpath = outPath, ploidy=2)
  

  computePiPerCallableSites(msprimeVCF = outPath,windowSize = windowSize, totalGenomeLength=totalGenomeLength)
  
  
}