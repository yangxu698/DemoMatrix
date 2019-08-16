library(dplyr)
library(readstata13)
library(foreach)
library(doParallel)
library(Matrix)
source("tstats_fun.r")
setwd("../Pt2Matrices-selected")
core_number = 24
## Part1 Read the data files as matrix
## 4 Network Matrix
## 2 var-cov Matrix
## 4 estc Matrix

##### Network-N  #####
W_ = read.dta13("W_N.dta") %>% select(afg1900:zzb20175) %>% as.matrix() %>% Matrix()
Vcm = read.dta13("Vcm.dta") %>% as.matrix() %>% Matrix()
VCVM = read.dta13("VCVM.dta") %>% as.matrix() %>% Matrix()
estcf = read.dta13("estcfN.dta") %>% as.matrix() %>% Matrix()
estcf1 = read.dta13("estcfN1.dta") %>% as.matrix() %>% Matrix()

## Calculation of rho, phi, beta
## estcfN1_inverse = solve(estcfN1)
estcf1_inverse = Matrix::solve(estcf1)

d_cf_rho1 = estcf %*% W_ %*% estcf1_inverse ## 10860*10860x10860*10860

d_cf_phi1 = estcf %*% estcf1_inverse  ## 10860x10860

d_cf_beta1 =  estcf1_inverse ## 10860x10860

VCVM_sub = VCVM[c(1,5,6), c(1,5,6)]  ## 3*3

## focus = 1:10860
## reset_colnames = c(paste0("DMseN_",focus), paste0("DMtstatsN_",focus))
deltaN = as.data.frame(c())

registerDoParallel(core_number)
Result = foreach ( i = 1:10860, .combine = 'cbind')  %dopar% {

    tstats_fun(i)
}

DMseN_result = Result %>% select(contains("DMse"))
DMtstatsN_result = Result %>% select(contains("DMtstats"))
geo_time_info = read.csv("geo_time_info.csv")
cbind(geo_time_info, DMseN_result) -> DMseN_result
cbind(geo_time_info, DMtstatsN_result) -> DMtstatsN_result

write.csv(DMseN_result, "../DemoMatrix/Result_All/DMseN_result.csv", row.names = FALSE)
write.csv(DMtstatsN_result, "../DemoMatrix/Result_All/DMtstatsN_result.csv", row.names = FALSE)
