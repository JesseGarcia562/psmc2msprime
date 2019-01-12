withScriptGenerateMultiHetSep<-function(scriptPath, outPathVCF, outPathMultiHetSep, totalGenomeLength = 3e+06, seed=30) 
{
  source_python(scriptPath)
  simulation <- msmc_model(length = totalGenomeLength, seed = seed, mu = 1.01e-08)
  writeVCFOfSimulation(simulation, outpath = outPathVCF, ploidy = 2)
  generateMultiHetSep(msprimeVCF = outPathVCF, outpath = outPathMultiHetSep)
}
