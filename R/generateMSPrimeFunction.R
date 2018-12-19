generateMSPrimeFunction<-function(textOfFunction,outPath, PopulationParametersChangeInput){
  #browser()
  fn<-glue::glue(glue::glue("{textOfFunction}"), PopulationParametersChange= PopulationParametersChangeInput)
  readr::write_file(fn,path=outPath)
}
