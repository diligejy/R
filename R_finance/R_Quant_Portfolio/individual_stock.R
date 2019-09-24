
# 한국거래소 개별종목 
# https://marketdata.krx.co.kr/mdi?fbclid=IwAR2zff5RCRAOwRfX2RiZN_To245SHiKRcJ29rDZ4Gdby0j01DyvRmRHeArY#document=13020401
library(httr)
library(rvest)
library(readr)

get_otp_url = 
  'https://marketdata.krx.co.kr/contents/COM/GenerateOTP.jspx'

get_otp_data = list(
  name: 'fileDown',
  filetype: 'csv',
  url: 'MKD/13/1302/13020401/mkd13020401',
  market_gubun: 'ALL',
  gubun: '1',
  schdate: '20190924',
  pagePath: '/contents/MKD/13/1302/13020401/MKD13020401.jsp'
)

otp = POST(get_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()

down_url = 'http://file.krx.co.kr/download.jspx'
down_ind = POST(down_url, query = list(code = otp),
                add_headers(referer = gen_otp_url)) %>%
  read_html() %>%
  html_text() %>%
  read_csv()

print(down_ind)

write.csv(down_ind, 'C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/krx_ind.csv')

# 네이버 Finance로 최근 영업일 구하기

library(httr)
library(rvest)
library(stringr)

url = 'https://finance.naver.com/sise/sise_deposit.nhn'

biz_day = GET(url) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_nodes(xpath = 
               '//*[@id="type_0"]/div/ul[2]/li/span') %>%
  html_text() %>%
  str_match(('[0-9]+.[0-9]+.[0-9]+')) %>%
  str_replace_all('\\.', '')

print(biz_day)


# 전체 코드
library(httr)
library(rvest)
library(stringr)
library(readr)

# 최근 영업일 구하기
url = 'https://finance.naver.com/sise/sise_deposit.nhn'

biz_day = GET(url) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_nodes(xpath = 
               '//*[@id="type_0"]/div/ul[2]/li/span') %>%
  html_text() %>%
  str_match(('[0-9]+.[0-9]+.[0-9]+')) %>%
  str_replace_all('\\.', '')

# 산업별 현황 OTP 발급

gen_otp_url = 
  'http://marketdata.krx.co.kr/contents/COM/GenerateOTP.jspx'

gen_otp_data = list(
  name = 'fileDown',
  filetype = 'csv',
  url = 'MKD/03/0303/0303/0103/mkd03030103',
  tp_cd = 'ALL',
  date = biz_day, # 최근 영업일로 변경
  lang = 'ko',
  pagePath = '/contents/MKD/03/0303/03030103/MKD03030103.jsp'
)

otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()

# 산업별 현황 데이터 다운로드
down_url = 'http://file.krx.co.kr/download.jspx'
down_sector = POST(down_url, query = list(code = otp),
                   add_headers(referer = gen_otp_url)) %>%
  read_html() %>%
  html_text() %>%
  read_csv()

ifelse(dir.exists('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data'), FALSE, dir.create('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data'))
write.csv(down_sector, 'C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/krx_sector.csv')

# 개별종목 지표 OTP 발급
gen_otp_url =
  'http://marketdata.krx.co.kr/contents/COM/GenerateOTP.jspx'
gen_otp_data = list(
  name = 'fileDown',
  filetype = 'csv',
  url = "MKD/13/1302/13020401/mkd13020401",
  market_gubun = 'ALL',
  gubun = '1',
  schdate = biz_day, # 최근영업일로 변경
  pagePath = '/contents/MKD/13/1302/13020401/MKD13020401.jsp')

otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()

# 개별종목 지표 데이터 다운로드
down_url = 'http://file.krx.co.kr/download.jspx'
down_ind = POST(down_url, query = list(code = otp),
                add_headers(referer = gen_otp_url)) %>%
  read_html() %>%
  html_text() %>%
  read_csv()

write.csv(down_ind, 'C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/krx_ind.csv')
