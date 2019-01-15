writeVCFOfSimulation<-function(simulation, outpath, ploidy=2){
  py <- reticulate::import_builtins()
  with(py$open(outpath, "w") %as% file, {
    simulation$write_vcf(file,  ploidy=as.integer(ploidy))
  })
  
  
}
