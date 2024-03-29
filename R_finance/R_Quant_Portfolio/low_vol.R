
# 저변동성 포트폴리오 구하기 : 일간 기준

library(stringr)
library(xts)
library(PerformanceAnalytics)
library(magrittr)
library(ggplot2)
library(dplyr)

KOR_price = read.csv('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_price.csv', row.names = 1,
                     stringsAsFactors = FALSE) %>% as.xts()
KOR_ticker = read.csv('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_ticker.csv', row.names = 1, 
                      stringsAsFactors = FALSE)
KOR_ticker$'종목코드' = 
  str_pad(KOR_ticker$'종목코드', 6, 'left', 0)

ret = Return.calculate(KOR_price)
std_12m_daily = xts::last(ret, 252) %>% apply(., 2, sd) %>%
  multiply_by(sqrt(252))

# 변동성 0인 종목 => 1년간 거래정지 -> NA처리
std_12m_daily %>%
  data.frame() %>%
  ggplot(aes(x = (`.`))) +
  geom_histogram(binwidth = 0.01) + 
  annotate("rect", xmin = -0.02, xmax = 0.02,
           ymin = 0,
           ymax = sum(std_12m_daily == 0, na.rm = TRUE) * 1.1,
           alpha = 0.3, fill = "red") +
  xlab(NULL)

std_12m_daily[std_12m_daily == 0] = NA

std_12m_daily[rank(std_12m_daily) <= 30]

invest_lowvol = rank(std_12m_daily) <= 30
KOR_ticker[invest_lowvol, ] %>%
  select(`종목코드`, `종목명`) %>%
  mutate(`변동성` = round(std_12m_daily[invest_lowvol], 4))

# 저변동성 포트폴리오 구하기(주간)
std_12m_weekly = xts::last(ret, 252) %>%
  apply.weekly(Return.cumulative) %>%
  apply(., 2, sd) %>% multiply_by(sqrt(52))

std_12m_weekly[std_12m_weekly == 0] = NA

std_12m_weekly[rank(std_12m_weekly) <= 30]

invest_lowvol_weekly = rank(std_12m_weekly) <= 30
KOR_ticker[invest_lowvol_weekly,] %>%
  select(`종목코드`, `종목명`) %>%
  mutate(`변동성` = 
           round(std_12m_weekly[invest_lowvol_weekly], 4))
