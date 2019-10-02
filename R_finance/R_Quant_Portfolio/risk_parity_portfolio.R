
get_RC = function(w, covmat) {
  port_vol = t(w) %*% covmat %*% w
  port_std = sqrt(port_vol)
  
  MRC = (covmat %*% w) / as.numeric(port_std)
  RC = MRC * w
  RC = c(RC / sum(RC))
  
  return(RC)
}

# 주식 60%와 채권 40% 포트폴리오의 위험기여도
ret_stock_bond = rets[, c(1, 5)]
cov_stock_bond = cov(ret_stock_bond)
RC_stock_bond = get_RC(c(0.6, 0.4), cov_stock_bond)
RC_stock_bond = round(RC_stock_bond, 4)

print(RC_stock_bond)

# rp() 함수를 이용한 최적화

library(cccp)

opt = rp(x0 = rep(0.1, 10),
         P = covmat,
         mrc = rep(0.1, 10))

w = getx(opt) %>% drop()
w = (w / sum(w)) %>%
  round(., 4) %>%
  setNames(colnames(rets))

print(w)

get_RC(w, covmat)

# 위험 예산 포트폴리오

library(cccp)

opt = rp(x0 = rep(0.1, 10),
         P = covmat,
         mrc = c(0.15, 0.15, 0.15, 0.15, 0.10,
                 0.10, 0.05, 0.05, 0.05, 0.05))

w = getx(opt) %>% drop()
w = (w / sum(w)) %>%
  round(., 4) %>%
  setNames(colnames(rets))

print(w)

get_RC(w, covmat)
