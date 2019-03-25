# psmc2msprime
Convert output from PSMC' or MSMC to a function for simulating under the inferred demography under msprime


# Installing and loading the package
```r
install.packages("devtools")
install.packages("tidyverse")
install.packages("glue")
devtools::install_github("jessegarcia562/psmc2msprime")
library(tidyverse)
library(glue)
library(psmc2msprime)
```

# Reading PSMC' output and turning into an msprime function
```r
readMSMCInference("../data/qlobata_reference_demography.msmc.out.final.txt", mutationRate = 1e-8) %>%
  generatePopulationParameterChanges() %>%
  generateMSPrimeFunction(outpath = "../code/qlobata_reference_msprime_function.py")
```

