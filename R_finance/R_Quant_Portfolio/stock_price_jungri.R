
library(stringr)
library(xts)
library(magrittr)

KOR_ticker = read.csv('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_ticker.csv', row.names = 1)
KOR_ticker$'종목코드' = str_pad(KOR_ticker$'종목코드', 6, side = c('left'), pad = '0')

price_list =list()

for (i in 1 : nrow(KOR_ticker)){
  
  name = KOR_ticker[i, '종목코드']
  price_list[[i]] =
    read.csv(paste0('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_price/',
                    name, '_price.csv'), row.names = 1) %>%
    as.xts()
  
}
