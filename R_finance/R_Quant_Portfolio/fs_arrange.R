
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

price_list = do.call(cbind, price_list) %>% na.locf()
print(head(price_list))
colnames(price_list) = KOR_ticker$'종목코드'

head(price_list[, 1:5])

write.csv(data.frame(price_list), 'C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_price.csv')

# 재무제표 정리하기

library(stringr)
library(magrittr)
library(dplyr)

KOR_ticker = read.csv('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_ticker.csv', row.names = 1)
KOR_ticker$'종목코드' =
  str_pad(KOR_ticker$'종목코드', 6, side = c('left'), pad = '0')

data_fs = list()

for (i in 1 : nrow(KOR_ticker)){
  
  name = KOR_ticker[i, '종목코드']
  data_fs[[i]] = read.csv(paste0('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_fs/', name,
                                 '_fs.csv'), row.names = 1)
}

fs_item = data_fs[[1]] %>% rownames()

length(fs_item)

print(head(fs_item))

select_fs = lapply(data_fs, function(x){
  # 해당 항목이 있을시 데이터를 선택
  if('매출액' %in% rownames(x)){
    x[which(rownames(x) == '매출액'), ]
    
    ## 해당 항목이 존재하지 않을 시, NA로 된 데이터프레임 생성
  } else {
    data.frame(NA)
  }
})

select_fs = bind_rows(select_fs)

print(head(select_fs))

select_fs = select_fs[!colnames(select_fs) %in%
                        c('.', 'NA.')]
select_fs = select_fs[, order(names(select_fs))]

rownames(select_fs) = KOR_ticker[, '종목코드']

print(head(select_fs))


fs_list = list()

for (i in 1 : length(fs_item)){
  select_fs = lapply(data_fs, function(x){
    # 해당 항목이 있을 시 데이터 선택
    if (fs_item[i] %in% rownames(x)){
      x[which(rownames(x) == fs_item[i]), ]
    } else{
      data.frame(NA)
    }
  })
  # 리스트 데이터를 행으로 묶어줌 
  select_fs = bind_rows(select_fs)
  
  # 열이름이 '.' 혹은 'NA.'인 지점은 삭제 (NA 데이터)
  select_fs = select_fs[!colnames(select_fs) %in%
                          c('.', 'NA.')]
  
  # 연도 순별로 정리
  select_fs = select_fs[, order(names(select_fs))]
  
  # 행이름을 티커로 변경
  rownames(select_fs) = KOR_ticker[, '종목코드']
  
  # 리스트에 최종 저장
  fs_list[[i]] = select_fs
  
}

# 리스트 이름을 재무 항목으로 변경
names(fs_list) = fs_item

saveRDS(fs_list, 'C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_fs.Rds')
