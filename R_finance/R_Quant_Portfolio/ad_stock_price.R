
library(stringr)

KOR_ticker = read.csv('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_ticker.csv'
                      , row.names = 1)

print(KOR_ticker$'종목코드'[1])

## 6자리로 만들어주기
KOR_ticker$'종목코드' =
  str_pad(KOR_ticker$'종목코드', 6, side = c('left'), pad = '0')
library(xts)

ifelse(dir.exists('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_price'), FALSE,
       dir.create('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_price'))

i = 1
name = KOR_ticker$'종목코드'[i]

price = xts(NA, order.by = Sys.Date())
print(price)

library(httr)
library(rvest)

url = paste0(
  'https://fchart.stock.naver.com/sise.nhn?symbol=',
  name,'&timeframe=day&count=500&requestType=0')
data = GET(url)
data_html = read_html(data, encoding = 'EUC-KR') %>%
  html_nodes('item') %>%
  html_attr('data') 

print(head(data_html))

print(head(data_html))

library(readr)

price = read_delim(data_html, delim = '|')
print(head(price))

library(lubridate)
library(timetk)

price = price[c(1, 5)] 
price = data.frame(price)
print(head(price))
colnames(price) = c('Date', 'Price')
print(head(price))
price[, 1] = ymd(price[, 1])
print(head(price))
price = tk_xts(price, date_var = Date)
print(tail(price))

write.csv(price, paste0('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_price/', name,
                        '_price.csv'))

# 전 종목 주가 크롤링

library(httr)
library(rvest)
library(stringr)
library(xts)
library(lubridate)
library(readr)

KOR_ticker = read.csv('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_ticker.csv', row.names = 1)
print(KOR_ticker$'종목코드'[1])
KOR_ticker$'종목코드' = 
  str_pad(KOR_ticker$'종목코드', 6, side = c('left'), pad = '0')

ifelse(dir.exists('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_price'), FALSE,
       dir.create('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_price'))

for (i in 1 : nrow(KOR_ticker)){
  
  price = xts(NA, order.by = Sys.Date()) # 빈 시계열 데이터
  name = KOR_ticker$'종목코드'[i] # 티커 부분 선택
  
  # 오류 발생 시 이를 무시하고 다음 루프로 진행
  tryCatch({
    # url 생성
    url = paste0(
      'https://fchart.stock.naver.com/sise.nhn?symbol=',
      name, '&timeframe=day&count=500&requestType=0'
    )
    
    # 이 후 과정은 위와 동일함
    # 데이터 다운로드
    data = GET(url)
    data_html = read_html(data, encoding = 'EUC-KR') %>%
      html_nodes("item") %>%
      html_attr("data")
    
    # 데이터 나누기
    price = read_delim(data_html, delim = '|')
  
    # 필요한 열만 선택 후 클렌징
    price = price[c(1, 5)]
    price = data.frame(price)
    colnames(price) = c('Date', 'Price')
    price[, 1] = ymd(price[, 1])
    
    rownames(price) = price[, 1]
    price[, 1] = NULL
    
    
    }, error = function(e){
      
      # 오류 발생 시 해당 종목명을 출력하고 다음 루프로 이동
      warning(paste0("Error in Ticker :", name) )
    })

  # 다운로드 받은 파일을 생성한 폴더 내 csv 파일로 저장
  write.csv(price, paste0('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_price/', name, '_price.csv'))
  
  # 타임 슬립 적용
  Sys.sleep(2)
    
  }