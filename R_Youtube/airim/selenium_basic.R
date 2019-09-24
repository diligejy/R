

library(httr)
library(rvest)
library(RSelenium)

remD <- remoteDriver(port = 4445L, # 포트번호 입력
                     browserName = "chrome") # 사용할 브라우저

remD$open() # 서버에 연결

title_you <- "홍진영"

remD$navigate(paste0("https://ugong2san.tistory.com"))
remD$navigate(paste0("https://www.youtube.com/results?search_query=", title_you))
# paste0() = 입력값들을 붙여주는 함수

html <- remD$getPageSource()[[1]]
html <- read_html(html) # 페이지의 소스 읽어오기

youtube_title <- html %>% html_nodes("#video-title") %>%
html_text() # 선택할 노드를 텍스트 화화

youtube_title[1:10]

# gsub() : 지정된 텍스트를 원하는 형태로 변경
youtube_title <- gsub("\n", "", youtube_title) # 데이터 정제 1
youtube_title <- trimws(youtube_title) # 데이터 정제 2

youtube_title[1:10]

# write.table() : 텍스트 파일로 저장

write.table(youtube_title,
            file = "C:/Users/jinyoung/Desktop/R_Youtube/airim/jinyoung_title.txt",
            sep = ",",
            row.names = FALSE,
            quote = FALSE)
