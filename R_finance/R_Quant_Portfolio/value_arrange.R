

library(stringr)
library(magrittr)
library(dplyr)

KOR_ticker = read.csv('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_ticker.csv', row.names = 1)
KOR_ticker$'종목코드' =
  str_pad(KOR_ticker$'종목코드', 6, side = c('left'), pad = '0')

data_value = list()

for (i in 1 : nrow(KOR_ticker)){
  
  name = KOR_ticker[i, '종목코드']
  data_value[[i]] =
    read.csv(paste0('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_value/', name,
                    '_value.csv'), row.names = 1) %>%
    t() %>% data.frame()
  
}

data_value = bind_rows(data_value)
print(head(data_value))

data_value = data_value[colnames(data_value) %in%
                          c('PER','PBR', 'PCR', 'PSR')]
rownames(data_value) = KOR_ticker[, '종목코드']

print(head(data_value))

data_value = data_value %>%
  mutate_all(list(~na_if(., Inf)))

write.csv(data_value, 'C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_value.csv')