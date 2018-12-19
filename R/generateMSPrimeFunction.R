generateMSPrimeFunction<-function(textOfFunction,outPath){
  #browser()
  fn<-glue::glue(glue::glue("{textOfFunction}"))
  readr::write_file(fn,path=outPath)
}
