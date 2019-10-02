
# 퀄리티: 자기자본이익률, 매출총이익, 영업활동현금흐름
# 밸류: PER, PBR, PSR, PCR
# 모멘텀: 3개월 수익률, 6개월 수익률, 12개월 수익률

library(xts)
library(stringr)

KOR_fs = readRDS('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_fs.Rds')
KOR_value = read.csv('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_value.csv', row.names = 1,
                     stringsAsFactors = FALSE)
KOR_price = read.csv('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_price.csv', row.names = 1,
                     stringsAsFactors = FALSE) %>% as.xts()

KOR_ticker = read.csv('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_ticker.csv', row.names = 1,
                      stringsAsFactors = FALSE)
KOR_ticker$'종목코드' = 
  str_pad(KOR_ticker$'종목코드', 6, 'left', 0)

num_col = ncol(KOR_fs[[1]])
quality_roe = (KOR_fs$'지배주주순이익' / KOR_fs$'자본')[num_col]
quality_gpa = (KOR_fs$'매출총이익' / KOR_fs$'자산')[num_col]
quality_cfo = (KOR_fs$'영업활동으로인한현금흐름' / KOR_fs$'자산')[num_col]

quality_profit = 
  cbind(quality_roe, quality_gpa, quality_cfo) %>%
  setNames(., c('ROE', 'GPA', 'CFO'))

factor_quality = quality_profit %>%
  mutate_all(list(~min_rank(desc(.)))) %>%
  mutate_all(list(~scale(.))) %>%
  rowSums()

factor_quality %>%
  data.frame() %>%
  ggplot(aes(x = `.`)) + 
  geom_histogram()

factor_value = KOR_value %>%
  mutate_all(list(~min_rank(.))) %>%
  mutate_all(list(~scale(.))) %>%
  rowSums()

factor_value %>%
  data.frame() %>%
  ggplot(aes(x = `.`)) + 
  geom_histogram()

library(PerformanceAnalytics)
library(dplyr)

ret_3m = Return.calculate(KOR_price) %>% xts::last(60) %>%
  sapply(., function(x) {prod(1+x) -1})
ret_6m = Return.calculate(KOR_price) %>% xts::last(120) %>%
  sapply(., function(x) {prod(1+x) -1})
ret_12m = Return.calculate(KOR_price) %>% xts::last(252) %>%
  sapply(., function(x) {prod(1+x) -1})
ret_bind = cbind(ret_3m, ret_6m, ret_12m) %>% data.frame()

factor_mom = ret_bind %>%
  mutate_all(list(~min_rank(desc(.)))) %>%
  mutate_all(list(~scale(.))) %>%
  rowSums()

factor_mom %>%
  data.frame() %>%
  ggplot(aes (x = `.`)) +
  geom_histogram()

library(corrplot)

cbind(factor_quality, factor_value, factor_mom) %>%
  data.frame() %>%
  setNames(c('Quality', 'Value', 'Momentum')) %>%
  cor(use = 'complete.obs') %>%
  round(., 2) %>%
  corrplot(method = 'color', type = 'upper',
           addCoef.col = 'black', number.cex = 1,
           tl.cex = 0.6, tl.srt = 45, tl.col = 'black',
           col =
             colorRampPalette(c('blue', 'white', 'red'))(200),
           mar=c(0,0,0.5,0))

factor_qvm = 
  cbind(factor_quality, factor_value, factor_mom) %>%
  data.frame() %>%
  mutate_all(list(~scale(.))) %>%
  mutate(factor_quality = factor_quality * 0.33,
         factor_value = factor_value * 0.33,
         factor_mom = factor_mom * 0.33) %>%
  rowSums()

invest_qvm = rank(factor_qvm) <= 30

library(tidyr)

quality_profit[invest_qvm, ] %>%
  gather() %>%
  ggplot(aes(x = value)) +
  geom_histogram() +
  facet_wrap(. ~key, scale = 'free', ncol = 1) +
  xlab(NULL)

KOR_value[invest_qvm, ] %>%
  gather() %>%
  ggplot(aes(x = value)) +
  geom_histogram() +
  facet_wrap(. ~key, scale = 'free', ncol = 1) +
  xlab(NULL)

ret_bind[invest_qvm,] %>%
  gather() %>%
  ggplot(aes(x = value)) +
  geom_histogram() +
  facet_wrap(. ~key, scale = 'free', ncol = 1) +
  xlab(NULL)

KOR_ticker[invest_qvm, ] %>%
  select('종목코드', '종목명') %>%
  cbind(round(quality_roe[invest_qvm,], 2)) %>%
  cbind(round(KOR_value$PBR[invest_qvm], 2)) %>%
  cbind(round(ret_12m[invest_qvm], 2)) %>%
  setNames(c('종목코드', '종목명', 'ROE', 'PBR', '12M'))


cbind(quality_profit, KOR_value, ret_bind)[invest_qvm, ] %>%
  apply(., 2, mean) %>% round(3) %>% t()
