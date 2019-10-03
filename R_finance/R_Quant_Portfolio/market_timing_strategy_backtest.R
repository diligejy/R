
library(quantmod)
library(PerformanceAnalytics)

symbols = c('SPY', 'SHY')
getSymbols(symbols, src = 'yahoo')

prices = do.call(cbind,
                 lapply(symbols, function(x) Ad(get(x))))
rets = na.omit(Return.calculate(prices))

ep = endpoints(rets, on = 'months')

print(ep)

wts = list()
lookback = 10

i = lookback + 1
sub_price = prices[ep[i-lookback] : ep[i] , 1]

head(sub_price, 3)

tail(sub_price, 3)

sma = mean(sub_price)

wt = rep(0, 2)
wt[1] = ifelse(last(sub_price) > sma, 1, 0)
wt[2] = 1 - wt[1]

wts[[i]] = xts(t(wt), order.by = index(rets[ep[i]]))

ep = endpoints(rets, on = 'months')
wts = list()
lookback = 10

for (i in (lookback +1) : length(ep)) {
  sub_price = prices[ep[i-lookback] : ep[i], 1]
  sma = mean(sub_price)
  wt = rep(0, 2)
  wt[1] = ifelse(last(sub_price) > sma, 1, 0)
  wt[2] = 1 - wt[1]
  
  wts[[i]] = xts(t(wt), order.by = index(rets[ep[i]]))
}

wts = do.call(rbind, wts)

Tactical = Return.portfolio(rets, wts, verbose = TRUE)
portfolios = na.omit(cbind(rets[,1], Tactical$returns)) %>%
  setNames(c('매수 후 보유', '시점 선택 전략'))

charts.PerformanceSummary(portfolios,
                          main = "Buy & Hold vs Tactical")

turnover = xts(rowSums(abs(Tactical$BOP.Weight -
                             timeSeries::lag(Tactical$EOP.Weight)),
                       na.rm = TRUE),
               order.by = index(Tactical$BOP.Weight))

chart.TimeSeries(turnover)
