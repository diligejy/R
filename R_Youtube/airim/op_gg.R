
# op.gg talk 인기글 크롤링 연습

library(rvest)
library(RSelenium)
library(httr)

remD <- remoteDriver(remoteServerAddr = 'localhost',
                     port = 4445L, # 포트번호 입력
                     browserName = "chrome")
