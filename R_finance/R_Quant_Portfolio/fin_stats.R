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
