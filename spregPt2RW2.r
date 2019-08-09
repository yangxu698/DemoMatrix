library(dplyr)
library(readstata13)
setwd("~/Intake/Coppedge")
## Part1 Read the data files as matrix
## 4 Network Matrix
## 2 var-cov Matrix
## 4 estc Matrix
W_N = read.dta13("W_N.dta") %>% select(afg1900:zzb20175) %>% as.matrix()
W_A = read.dta13("W_A.dta") %>% select(afg1900:zzb20175) %>% as.matrix()
CCol = read.dta13("CCol.dta") %>% select(afg1900:zzb20175) %>% as.matrix()
WFCol = read.dta13("FCol.dta") %>% select(afg1900:zzb20175) %>% as.matrix()
Vcm = read.dta13("Vcm.dta") %>% as.matrix()
VCVM = read.dta13("VCVM.dta") %>% as.matrix()
estcfN = read.dta13("estcfN.dta") %>% as.matrix()
estcfA = read.dta13("estcfA.dta") %>% as.matrix()
estcfC = read.dta13("estcfC.dta") %>% as.matrix()
estcfF = read.dta13("estcfF.dta") %>% as.matrix()
estcfN1 = read.dta13("estcfN1.dta") %>% as.matrix()
estcfA1 = read.dta13("estcfA1.dta") %>% as.matrix()
estcfC1 = read.dta13("estcfC1.dta") %>% as.matrix()
estcfF1 = read.dta13("estcfF1.dta") %>% as.matrix()

## Calculation of rho, phi, beta

d_cf_rhoN1 = estcfN %*% W_N %*% solve(estcfN1) ## 10860*10860x10860*10860
d_cf_rhoA1 = estcfA %*% W_A %*% solve(estcfA1)
d_cf_rhoC1 = estcfC %*% W_C %*% solve(estcfC1)
d_cf_rhoF1 = estcfF %*% W_F %*% solve(estcfF1)

d_cf_phiN1 = estcfN %*% solve(estcN1) ## 10860x10860
d_cf_phiA1 = estcfA %*% solve(estcA1)
d_cf_phiC1 = estcfC %*% solve(estcC1)
d_cf_phiF1 = estcfF %*% solve(estcF1)

d_cf_betaN1 =  solve(estcfN1) ## 10860x10860
d_cf_betaA1 =  solve(estcfA1)
d_cf_betaC1 =  solve(estcfC1)
d_cf_betaF1 =  solve(estcfF1)

VCVMn = VCVM[c(1,5,6), c(1,5,6)]  ## 3*3
VCVMa = VCVM[c(2,5,6), c(2,5,6)]
VCVMc = VCVM[c(3,5,6), c(3,5,6)]
VCVMf = VCVM[c(4,5,6), c(4,5,6)]

d_cf_rhoN = d_cf_rhoN1[,i]  ## 10860x1
d_cf_phiN = d_cf_phiN1[,i]
d_cf_betaN = d_cf_betaN1[,i]

d_cfN = cbind(d_cf_rhoN, d_cf_phiN, d_cf_betaN) ## 10860x3

deltaN1 = d_cfN %*% VCVMn %*% t(d_cfN) ## 10860x3 * 3*3 * 3*10860
deltaN = diag(deltaN1) ## 10860

focus = seq(169, 10860, 181)

DMseN = sqrt( deltaN[focus] )
DMtstatsN = estcfN/DMseN
