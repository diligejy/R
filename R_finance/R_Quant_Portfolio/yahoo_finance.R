
library(httr)
library(rvest)

url_IS = paste0(
  'https://finance.yahoo.com/quote/005930.KS/financials?p=',
  '005930.KS')

url_BS = paste0(
  'https://finance.yahoo.com/quote/005930.KS/balance-sheet?p=',
  '005930.KS')

url_CF = paste0(
  'https://finance.yahoo.com/quote/005930.KS/cash-flow?p=',
  '005930.KS')

yahoo_finance_xpath =
  '//*[@id="Col1-1-Financials-Proxy"]/section/div[3]/table'

data_IS = GET(url_IS) %>%
  read_html() %>%
  html_node(xpath = yahoo_finance_xpath) %>%
  html_table()

data_BS = GET(url_BS) %>%
  read_html() %>%
  html_node(xpath = yahoo_finance_xpath) %>%
  html_table()

data_CF = GET(url_CF) %>%
  read_html() %>%
  html_node(xpath = yahoo_finance_xpath) %>%
  html_table()

data_fs = rbind(data_IS, data_BS, data_CF)

print(head(data_fs))

# 데이터 클렌징
library(stringr)

data_fs = data_fs[!duplicated(data_fs[, 1]), ]
rownames(data_fs) = NULL
rownames(data_fs) = data_fs[, 1]

colnames(data_fs) = data_fs[1, ]

data_fs = data_fs[-1, ]

data_fs = data_fs[, substr(colnames(data_fs), 1, 2) == '12']

data_fs = sapply(data_fs, function(x){
  str_replace_all(x, ',', '') %>%
    as.numeric()
}) %>%
  data.frame(., row.names = rownames(data_fs))

print(head(data_fs))

value_type = 
  c('Net Income Applicable To Common Shares', # Earings
    "Total stockholders' equity", # Book Value
    'Total Cash Flow From Operating Activities', # Cash Flow
    'Total Revenue') #Sales

value_index = data_fs[match(value_type, rownames(data_fs)), 1]

print(value_index)

url = paste0(
  'https://finance.yahoo.com/quote/005930.KS/',
  'key-statistics?p=005930.KS'
)

data = GET(url)

price = read_html(data) %>%
  html_node(
    xpath =
      '//*[@id="quote-header-info"]/div[3]/div/div/span[1]') %>%
  html_text() %>%
  parse_number()

print(price)

share_xpath = 
  paste0('//*[@id="Col1-0-KeyStatistics-Proxy"]/section',
         '/div[2]/div[2]/div/div[2]/div/table/tbody/tr[3]/td[2]')

share_yahoo = read_html(data) %>%
  html_node(xpath = share_xpath) %>%
  html_text()
  
print(share_yahoo)

library(stringr)

share_unit = str_match(share_yahoo, '[a-zA-Z]')
print(share_unit)

share_multiplier = switch(share_unit,
                          'M' = { 1000000 },
                          'B' = { 1000000000 },
                          'T' = { 1000000000000 }
                          )

print(share_multiplier)

share_yahoo = share_yahoo %>%
  str_match('[0-9.0-9]*') %>% as.numeric()
share_yahoo = share_yahoo * share_multiplier

print(share_yahoo)

data_value_yahoo = price / (value_index * 1000 / share_yahoo)
names(data_value_yahoo) = c('PER', 'PBR', 'PCR', 'PSR')

data_value_yahoo[data_value_yahoo < 0] = NA
print(data_value_yahoo)
