
library(stringr)

KOR_ticker = read.csv('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_ticker.csv', row.names = 1, stringsAsFactors = FALSE)
KOR_sector = read.csv('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_sector.csv', row.names = 1, stringsAsFactors = FALSE)

KOR_ticker$'종목코드' = 
  str_pad(KOR_ticker$'종목코드', 6, 'left', 0)

KOR_sector$'CMP_CD' = 
  str_pad(KOR_sector$'CMP_CD', 6, 'left', 0)

library(dplyr)

data_market = left_join(KOR_ticker, KOR_sector, 
                        by = c('종목코드' = 'CMP_CD',
                               '종목명' = 'CMP_KOR'))
head(data_market)

glimpse(data_market)

head(names(data_market), 10)

data_market = data_market %>%
  rename(`시가총액` = `시가총액.원.`)

head(names(data_market), 10)

data_market %>%
  distinct(SEC_NM_KOR) %>% c()

data_market %>%
  select(`종목명`) %>% head()
  
data_market %>%
  select(`종목명`, `PBR`, `SEC_NM_KOR`) %>% head()

data_market %>%
  select(starts_with('시')) %>% head()

data_market %>%
  select(ends_with('R')) %>% head()

data_market %>%
  select(contains('가')) %>% head()

data_market = data_market %>%
  mutate('PBR' = as.numeric(PBR),
         'PER' = as.numeric(PER),
         'ROE' = PBR / PER,
         'ROE' = round(ROE, 4),
         'size' = ifelse(`시가총액` >=
                           median(`시가총액`, na.rm = TRUE),
                         'big', 'small'))

data_market %>%
  select(`종목명`, `ROE`, `size`) %>% head()

data_market %>%
  select(`종목명`, `PBR`) %>%
  filter(`PBR` < 1) %>% head()

data_market %>%
  select(`종목명`, `PBR`, `PER`, `ROE`) %>%
  filter(PBR < 1 & PER < 20 & ROE > 0.1 ) %>% head()

data_market %>%
  summarize(PBR_max = max(PBR, na.rm = TRUE),
            PBR_min = min(PBR, na.rm = TRUE))

data_market %>%
  select(PBR) %>%
  arrange(PBR) %>%
  head(5)

data_market %>%
  mutate(PBR_rank = row_number(PBR)) %>%
  select(`종목명`, PBR, PBR_rank) %>%
  arrange(PBR) %>%
  head(5)

data_market %>%
  mutate(PBR_rank = row_number(desc(ROE))) %>%
  select(`종목명`, ROE, PBR_rank) %>%
  arrange(desc(ROE)) %>%
  head(5)

data_market %>%
  mutate(PBR_title = ntile(PBR, n = 5)) %>%
  select(PBR, PBR_title) %>%
  head()

data_market %>%
  group_by(`SEC_NM_KOR`) %>%
  summarize(n())

data_market %>%
  group_by(`SEC_NM_KOR`) %>%
  summarize(PBR_median = median(PBR, na.rm = TRUE)) %>%
  arrange(PBR_median)

data_market %>%
  group_by(`시장구분`, `SEC_NM_KOR`) %>%
  summarize(PBR_median = median(PBR, na.rm = TRUE)) %>%
  arrange(PBR_median)
