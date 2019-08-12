library(dplyr)
library(readstata13)
library(foreach)
library(doParallel)
setwd("../Pt2Matrices-selected")
core_number = 4

estcfN1 = read.dta13("estcfN1.dta") %>% as.matrix()
estcfA1 = read.dta13("estcfA1.dta") %>% as.matrix()
estcfC1 = read.dta13("estcfC1.dta") %>% as.matrix()
estcfF1 = read.dta13("estcfF1.dta") %>% as.matrix()

list_all = list(estcfN1, estcfA1, estcfC1, estcfF1)
name = c("estcfN1", "estcfA1", "estcfC1", "estcfF1")
registerDoParallel(core_number)
Result_NULL = foreach( i = 1:4, .combine = 'c') %dopar% {

  inverse_matrix = solve(list_all[[i]])
  write.csv(inverse_matrix, paste0("../DemoMatrix/inverse_",name[i]), row.names = FALSE)
}
