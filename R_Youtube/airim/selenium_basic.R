

library(httr)
library(rvest)
library(RSelenium)

remD <- remoteDriver(port = 4445L, # 포트번호 입력
                     browserName = "chrome") # 사용할 브라우저

remD$open() # 서버에 연결

title_you <- "진영이 블로그"

remD$navigate(paste0("https://ugong2san.tistory.com"))
remD$navigate(paste0("https://www.youtube.com/results?search_query=", title_you))
