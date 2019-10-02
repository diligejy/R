
# 최소 분산 포트폴리오
library(quantmod)
library(PerformanceAnalytics)
library(magrittr)

symbols = c('SPY', # 미국주식
            'IEV', # 유럽주식
            'EWJ', # 일본주식
            'EEM', # 이머징주식
            'TLT', # 미국 장기채
            'IEF', # 미국 중기채
            'IYR', # 미국 리츠
            'RWX', # 글로벌 리츠
            'GLD', # 금
            'DBC' # 상품
            )

getSymbols(symbols, src = 'yahoo')

prices = do.call(cbind, lapply(symbols, function(x) Ad(get(x)))) %>%
  setNames(symbols)

rets = Return.calculate(prices) %>% na.omit()

library(tidyr)
library(dplyr)
library(corrplot)

cor(rets) %>%
  corrplot(method = 'color', type = 'upper',
           addCoef.col = 'black', number.cex = 0.7,
           tl.cex = 0.6, tl.srt = 45, tl.col = 'black',
           col = 
             colorRampPalette(c('blue', 'white', 'red'))(200),
           mar = c(0, 0, 0.5, 0))

covmat = cov(rets)

# slsqp() 함수를 이용한 최적화

objective = function(w){
  obj = t(w) %*% covmat %*% w
  return(obj)
}

hin.objective = function(w){
  return(w)
}

heq.objective = function(w) {
  sum_w = sum(w)
  return( sum_w - 1 )
}

library(nloptr)

result = slsqp(x0 = rep(0.1, 10),
               fn = objective,
               hin = hin.objective,
               heq = heq.objective)

print(result$par)

print(result$value)

w_1 = result$par %>% round(., 4) %>%
  setNames(colnames(rets))

print(w_1)

# solve.QP() 함수를 이용한 최적화
Dmat = covmat
dvec = rep(0, 10)
Amat = t(rbind(rep(1, 10), diag(10), -diag(10)))
bvec = c(1, rep(0, 10), -rep(1, 10))
meq = 1

library(quadprog)
result= solve.QP(Dmat, dvec, Amat, bvec, meq)

print(result$solution)

print(result$value)

w_2 = result$solution %>% round(., 4) %>%
  setNames(colnames(rets))

print(w_2)

# optimalPortfolio() 함수를 이용한 최적화

library(RiskPortfolios)

w_3 = optimalPortfolio(covmat,
                       control = list(type = 'minvol',
                                      constraint = 'lo')) %>%
  round(., 4) %>%
  setNames(colnames(rets))

print(w_3)

library(ggplot2)

data.frame(w_1) %>%
  ggplot(aes(x = factor(rownames(.), levels = rownames(.)),
             y = w_1)) +
  geom_col() +
  xlab(NULL) + ylab(NULL)

# 최소 및 최대 투자비중 제약조건

result = slsqp(x0 = rep(0.1, 10),
               fn = objective,
               hin = hin.objective,
               heq = heq.objective,
               lower = rep(0.05, 10),
               upper = rep(0.20, 10))

w_4 = result$par %>% round(., 4) %>%
  setNames(colnames(rets))

print(w_4)

Dmat = covmat
dvec = rep(0, 10)
Amat = t(rbind(rep(1, 10), diag(10), -diag(10)))
bvec = c(1, rep(0.05, 10), -rep(0.20, 10))
meq = 1

result = solve.QP(Dmat, dvec, Amat, bvec, meq)

w_5 = result$solution %>% round(., 4) %>%
  setNames(colnames(rets))

print(w_5)

w_6 = optimalPortfolio(covmat,
                       control = list(type = 'minvol',
                                      constraint = 'user',
                                      LB = rep(0.05, 10),
                                      UB = rep(0.20, 10))) %>%
  round(., 4) %>%
  setNames(colnames(rets))

print(w_6)

data.frame(w_4) %>%
  ggplot(aes(x = factor(rownames(.), levels = rownames(.)),
             y = w_4)) +
  geom_col() +
  geom_hline(aes(yintercept = 0.05), color = 'red') + 
  geom_hline(aes(yintercept = 0.20), color = 'red') + 
  xlab(NULL) + ylab(NULL)

Dmat = covmat
dvec = rep(0, 10)
Amat = t(rbind(rep(1, 10), diag(10), -diag(10))) 
bvec = c(1, c(0.10, 0.10, 0.05, 0.05, 0.10,
              0.10, 0.05, 0.05, 0.03, 0.03),
         -c(0.25, 0.25, 0.20, 0.20, 0.20,
            0.20, 0.10, 0.10, 0.08, 0.08))
meq = 1

result = solve.QP(Dmat, dvec, Amat, bvec, meq)

result$solution %>%
  round(., 4) %>%
  setNames(colnames(rets))
