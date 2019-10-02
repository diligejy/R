
library(quantmod)
library(PerformanceAnalytics)
library(magrittr)

symbols = c('102110.KS', '039490.KS')
getSymbols(symbols)

prices = do.call(cbind, 
                 lapply(symbols, function(x)Cl(get(x))))

ret = Return.calculate(prices)
ret = ret['2016-01::2018-12']

rm = ret[, 1]
ri = ret[, 2]

reg = lm(ri ~ rm)
summary(reg)

# 베타 시각화

plot(as.numeric(rm), as.numeric(ri), pch = 4, ces = 0.3,
     xlab = "KOSPI 200", ylab = "Individual Stock",
     xlim = c(-0.02, 0.02), ylim = c(-0.02, 0.02))
abline(a = 0, b = 1, lty = 2)
abline(reg, col = 'red')
