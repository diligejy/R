
# 한국 거래소 산업현황 크롤링

library(httr)
library(rvest)
library(readr)


# OTP 만들기

gen_otp_url = 
  'http://marketdata.krx.co.kr/contents/COM/GenerateOTP.jspx'

gen_otp_data = list(
  name = 'fileDown',
  filetype = 'csv',
  url = 'MKD/03/0303/03030103/mkd03030103',
  tp_cd = 'ALL',
  date = '20190924',
  lang = 'ko',
  pagePath = '/contents/MKD/03/0303/03030103/MKD03030103.jsp')

otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()


# OTP를 이용해 데이터 다운로드 하기

down_url = 'http://file.krx.co.kr/download.jspx'
down_sector = POST(down_url, query = list(code = otp),
                   add_headers(referer = gen_otp_url)) %>%
  read_html() %>%
  html_text() %>%
  read_csv()

ifelse(dir.exists('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data'), FALSE, dir.create('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data'))
write.csv(down_sector, 'C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/krx_sector.csv')
