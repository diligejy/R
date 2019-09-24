

library(quantmod)

getSymbols('AAPL')

head(AAPL)

chart_Series(Ad(AAPL))

data = getSymbols('AAPL',
                  from = '2000-01-01', 
                  auto.assign = FALSE)
tail(data)
