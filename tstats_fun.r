tstats_fun = function(i){

    d_cf = cbind(d_cf_rho1[,i], d_cf_phi1[,i], d_cf_beta1[,i]) %>% Matrix() ## 10860x3

    delta1 = d_cf %*% VCVM_sub %*% t(d_cf) ## 10860x3 * 3*3 * 3*10860
    temp_delta = diag(delta1) ## 10860

    temp_DMse = sqrt( temp_delta )
    temp_DMtstats = estcf[,i]/temp_DMse
    if(length(temp_DMse) != 10860 | length(temp_DMtstats) != 10860){
     print(c(i, length(temp_delta)) )
   } else {
    combined_result = cbind(setNames(data.frame(temp_DMse),  paste0("DMse_",i)),
                            setNames(data.frame(temp_DMtstats), paste0("DMtstats_",i)) )
   }
    return(combined_result)
}
