library(dplyr)
library(readstata13)
library(foreach)
library(doParallel)
library(Matrix)
source("tstats_fun.r")
setwd("../Pt2Matrices-selected")
core_number = 4
## Part1 Read the data files as matrix
## 4 Network Matrix
## 2 var-cov Matrix
## 4 estc Matrix

##### Network-N  #####
W_N = read.dta13("W_N.dta") %>% select(afg1900:zzb20175) %>% as.matrix() %>% Matrix()
Vcm = read.dta13("Vcm.dta") %>% as.matrix() %>% Matrix()
VCVM = read.dta13("VCVM.dta") %>% as.matrix() %>% Matrix()
estcfN = read.dta13("estcfN.dta") %>% as.matrix() %>% Matrix()
estcfN1 = read.dta13("estcfN1.dta") %>% as.matrix() %>% Matrix()

## Calculation of rho, phi, beta
## estcfN1_inverse = solve(estcfN1)
estcfN1_inverse = Matrix::solve(estcfN1)

d_cf_rhoN1 = estcfN %*% W_N %*% estcfN1_inverse ## 10860*10860x10860*10860

d_cf_phiN1 = estcfN %*% estcfN1_inverse  ## 10860x10860

d_cf_betaN1 =  estcfN1_inverse ## 10860x10860

VCVMn = VCVM[c(1,5,6), c(1,5,6)]  ## 3*3

focus = seq(169, 10860, 181)
reset_colnames = c(paste0("DMseN_",focus), paste0("DMstatsN_",focus))
deltaN = as.data.frame(c())

registerDoParallel(core_number)
Result = foreach ( i = focus, .combine = 'cbind')  %dopar% {

    tstats_fun(i)
##    d_cfN = cbind(d_cf_rhoN1[,i], d_cf_phiN1[,i], d_cf_betaN1[,i]) ## 10860x3
##
##    deltaN1 = d_cfN %*% VCVMn %*% t(d_cfN) ## 10860x3 * 3*3 * 3*10860
##    temp_deltaN = diag(deltaN1) ## 10860
##
##    temp_DMseN = sqrt( temp_deltaN[focus] )
##    temp_DMtstatsN = estcfN[,i]/temp_DMseN

##    DMseN = cbind(DMseN, temp_DMseN)
##    DMtstatsN = cbind(DMtstatsN, temp_DMtstatsN)
}

Result = Result %>% select(reset_colnames)
geo_time_info = read.csv("geo_time_info.csv")
cbind(geo_time_info, Result) -> Result
write.csv(Result, "../DemoMatrix/Result.csv", row.names = FALSE)
## write.csv(DMseN, "../DemoMatrix/DMseN.csv", row.names = FALSE)
## write.csv(DMtstatsN, "../DemoMatrix/DMtstatsN.csv", row.names = FALSE)


## W_A = read.dta13("W_A.dta") %>% select(afg1900:zzb20175) %>% as.matrix()
## CCol = read.dta13("CCol.dta") %>% select(afg1900:zzb20175) %>% as.matrix()
## WFCol = read.dta13("FCol.dta") %>% select(afg1900:zzb20175) %>% as.matrix()
##
##
## estcfA = read.dta13("estcfA.dta") %>% as.matrix()
## estcfC = read.dta13("estcfC.dta") %>% as.matrix()
## estcfF = read.dta13("estcfF.dta") %>% as.matrix()
##
##
## estcfA1 = read.dta13("estcfA1.dta") %>% as.matrix()
## estcfC1 = read.dta13("estcfC1.dta") %>% as.matrix()
## estcfF1 = read.dta13("estcfF1.dta") %>% as.matrix()
##
##
## d_cf_rhoA1 = estcfA %*% W_A %*% solve(estcfA1)
## d_cf_rhoC1 = estcfC %*% W_C %*% solve(estcfC1)
## d_cf_rhoF1 = estcfF %*% W_F %*% solve(estcfF1)
##
##
## d_cf_phiA1 = estcfA %*% solve(estcA1)
## d_cf_phiC1 = estcfC %*% solve(estcC1)
## d_cf_phiF1 = estcfF %*% solve(estcF1)
##
##
## d_cf_betaA1 =  solve(estcfA1)
## d_cf_betaC1 =  solve(estcfC1)
## d_cf_betaF1 =  solve(estcfF1)
##
##
## VCVMa = VCVM[c(2,5,6), c(2,5,6)]
## VCVMc = VCVM[c(3,5,6), c(3,5,6)]
## VCVMf = VCVM[c(4,5,6), c(4,5,6)]
