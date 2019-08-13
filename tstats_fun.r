tstats_fun = function(i){

    d_cfN = cbind(d_cf_rhoN1[,i], d_cf_phiN1[,i], d_cf_betaN1[,i]) %>% Matrix() ## 10860x3

    deltaN1 = d_cfN %*% VCVMn %*% t(d_cfN) ## 10860x3 * 3*3 * 3*10860
    temp_deltaN = diag(deltaN1) ## 10860

    temp_DMseN = sqrt( temp_deltaN[focus] )
    temp_DMtstatsN = estcfN[,i]/temp_DMseN
    combined_result = cbind(paste0("DMseN_",i) = temp_DMseN, paste0("DMtstatsN_",i)=temp_DMtstatsN)
    return(combined_result)
}
