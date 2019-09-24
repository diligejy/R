

library(rvest)
library(RSelenium)
library(httr)

remD <- remoteDriver(remoteServerAddr = 'localhost',
                     port = 4445L, # 포트번호 입력
                     browserName = "chrome")

remD$open() # 서버에 연결
remD$navigate("http://youtu.be/tZooW6PritE") # 홈페이지로 이동하라!

# 재생 및 일시정지를 위한 코드
btn <- remD$findElement(using="css selector",
                        value = ".html5-main-video")

btn$clickElement()

# 홈페이지 스크롤
remD$executeScript("window.scrollTo(0,500)")
remD$executeScript("window.scrollTo(500,1000)")
remD$executeScript("window.scrollTo(1000,1500)")

html <- remD$getPageSource()[[1]]
html <- read_html(html) # 페이지의 소스 읽어오기

youtube_comments <- html %>% html_nodes("#content-text") %>% html_text()
youtube_comments <- youtube_comments[1:50]

head(youtube_comments)


write.table(youtube_comments,
             file = "C:/Users/jinyoung/Desktop/R_Youtube/airim/youtube_comment.txt",
             sep = ",",
             row.names = FALSE,
             quote = FALSE)
