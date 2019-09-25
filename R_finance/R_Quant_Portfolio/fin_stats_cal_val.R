library(httr)
library(rvest)

ifelse(dir.exists('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_fs'), FALSE,
       dir.create('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_fs'))

Sys.setlocale("LC_ALL", "English")

url = paste0('http://comp.fnguide.com/SVO2/ASP/',
             'SVD_Finance.asp?pGB=1&gicode=A005930')

data = GET(url)
data = data %>%
  read_html() %>%
  html_table()

Sys.setlocale("LC_ALL", "Korean")

lapply(data, function(x) {
  head(x, 3)})

data_IS = data[[1]]
data_BS = data[[3]]
data_CF = data[[5]]

print(names(data_IS))

data_IS = data_IS[, 1:(ncol(data_IS) -2)]

data_fs = rbind(data_IS, data_BS, data_CF)
data_fs[, 1] = gsub('계산에 참여한 계정 펼치기',
                    '', data_fs[, 1])
data_fs = data_fs[!duplicated(data_fs[, 1]), ]
rownames(data_fs) = NULL
rownames(data_fs) = data_fs[, 1]
data_fs[, 1] = NULL

data_fs = data_fs[, substr(colnames(data_fs), 6, 7) == '12']
print(head(data_fs))

sapply(data_fs, typeof)


library(stringr)

data_fs = sapply(data_fs, function(x){
  str_replace_all(x, ',', '') %>%
    as.numeric()
}) %>%
  data.frame(., row.names = rownames(data_fs))

print(head(data_fs))

sapply(data_fs, typeof)

write.csv(data_fs, 'C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_fs/005930_fs.csv')



# 가치지표 크롤링


# 가치지표 계산
# PER, PBR, PCR, PSR

ifelse(dir.exists('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_value'), FALSE,
       dir.create('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_value'))

value_type = c('지배주주순이익',
               '자본',
               '영업활동으로인한현금흐름',
               '매출액')

value_index = data_fs[match(value_type, rownames(data_fs)),
                      ncol(data_fs)]
print(value_index)

library(readr)
url =
  paste0('http://comp.fnguide.com/SVO2/ASP/SVD_main.asp',
         '?pGB=1&gicode=A005930')
data = GET(url)

price = read_html(data) %>%
  html_node(xpath = '//*[@id="svdMainChartTxt11"]') %>%
  html_text() %>%
  parse_number()
print(price)


share = read_html(data) %>%
  html_node(
    xpath =
      '//*[@id="svdMainGrid1"]/table/tbody/tr[7]/td[1]') %>%
  html_text()

print(share)

share = share %>%
  strsplit('/') %>%
  unlist() %>%
  .[1] %>%
  parse_number

print(share)

data_value = price / (value_index * 100000000 / share)
names(data_value) = c('PER', 'PBR', 'PCR', 'PSR')
data_value[data_value < 0] = NA

print(data_value)

write.csv(data_value, 'C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_value/005930_value.csv')
