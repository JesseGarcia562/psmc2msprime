withScriptGeneratePi<-function(scriptPath, outPath, length=3e5){
  source_python(scriptPath)
  simulation<-msmc_model(length=length, seed=30, mu=1.01e-08)
  
  writeVCFOfSimulation(simulation, outpath = outPath, ploidy=2)
  

  computePiPerCallableSites(msprimeVCF = outPath,windowSize = 500000)
  
  
}