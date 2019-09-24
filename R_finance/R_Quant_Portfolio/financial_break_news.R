

# 크롤링을 할 때 주의해야 할 점이 있습니다. 
# 특정 웹사이트의 페이지를 쉬지 않고 크롤링하는 행위를 
# 무한 크롤링이라고 합니다. 
# 무한 크롤링은 해당 웹사이트의 자원을 독점하게 되어 
# 타인의 사용을 막게 되며 웹사이트에 부하를 주게 됩니다. 
# 일부 웹사이트에서는 동일한 IP로 쉬지 않고 크롤링을 할 경우 
# 접속을 막아버리는 경우도 있습니다. 
# 따라서 하나의 페이지를 크롤링한 후 1~2초 가량 정지하고 다시 다음 페이지를 크롤링하는 것이 좋습니다.

library(rvest)
library(httr)

url = paste0('https://finance.naver.com/news/news_list.nhn?',
             'mode=LSS2D&section_id=101&section_id2=258')
data = GET(url)

print(data)

data_title = data %>%
  read_html(encoding = 'EUC-KR') %>%
  html_nodes('dl') %>%
  html_nodes('.articleSubject') %>%
  html_nodes('a') %>%
  html_attr('title')

print(data_title)
