
# op.gg talk 인기글 크롤링 연습

library(rvest)
library(RSelenium)
library(httr)

remD <- remoteDriver(remoteServerAddr = 'localhost',
                     port = 4445L, # 포트번호 입력
                     browserName = "chrome")

remD$open() # 서버에 연결
remD$navigate("https://www.op.gg/") # 홈페이지로 이동하라!

html <- remD$getPageSource()[[1]]
html <- read_html(html) # 페이지의 소스 읽어오기
for (i in 1:10){
on_populars <- html_nodes(html, css = "div.community-best__content-left > ul >li:nth-child(deparse(i))")
}

on_popular <- unique(html_attr(link, 'href'))

op_popular
op_popular[1:10]
