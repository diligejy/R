
# 주가 그래프 나타내기

library(quantmod)

getSymbols('SPY') 
prices = Cl(SPY) # Cl : 종가만 추출

plot(prices, main = 'Price')

library(ggplot2)

SPY %>%
  ggplot(aes (x = Index, y = SPY.Close)) +
  geom_line()

# 인터렉티브 그래프 나타내기

library(dygraphs)

dygraph(prices) %>%
  dyRangeSelector()

library(highcharter)

highchart(type = 'stock') %>%
  hc_add_series(prices) %>%
  hc_scrollbar(enabled = FALSE)

library(plotly)

p = SPY %>%
  ggplot(aes(x = Index, y = SPY.Close)) + 
  geom_line()

ggplotly(p)

prices %>%
  fortify.zoo %>%
  plot_ly(x= ~Index, y = ~SPY.Close ) %>%
  add_lines()

# 연도별 수익률 나타내기

library(PerformanceAnalytics)

ret_yearly = prices %>%
  Return.calculate() %>%
  apply.yearly(., Return.cumulative) %>%
  round(4) %>%
  fortify.zoo() %>%
  mutate(Index = as.numeric(substring(Index, 1, 4)))

ggplot(ret_yearly, aes(x = Index, y = SPY.Close)) +
  geom_bar(stat = 'identity') + 
  scale_x_continuous(breaks = ret_yearly$Index,
                     expand = c(0.01, 0.01)) + 
  geom_text(aes(label = paste(round(SPY.Close * 100, 2), "%"),
                vjust = ifelse(SPY.Close >= 0, -0.5, 1.5)),
            position = position_dodge(width = 1),
            size = 3) +
  xlab(NULL) + ylab(NULL)
