setwd('./R/kosis')
getwd()
# 데이터 불러오기

install.packages('tidyverse')
install.packages('modelr')
library(tidyverse)
library(readxl)


birth_df <- read_excel('시군구_성_월별_출생.xlsx')

# 데이터 탐색하기
birth_df %>% dim()
View(birth_df)

colSums(is.na(birth_df))

birth_df$시점 %>%  head()

is.na(birth_df$시점) %>% head()
!is.na(birth_df$시점) %>% head()

# 원하는 행 걸러내기

birth_df %>% 
  filter(!is.na(시점)) %>% 
  head()

# 원하는 열 선택하기

birth_df %>% 
  filter(!is.na(시점)) %>% 
  select(시점, 전국) %>% 
  head()



# 컬럼의 정보를 나눠주는 separate
birth_df <- birth_df %>% 
  filter(!is.na(시점)) %>% 
  select(시점, 전국) %>% 
  separate(시점,
            into = c("년도", "월"))

birth_df %>% head()


# 테이블의 정보를 요약하는 summarise

birth_df %>% 
  group_by(월) %>% 
  summarise(평균출생수 = mean(전국))


# 데이터를 순서대로 정렬하는 arrange

birth_df %>% 
  group_by(월) %>% 
  summarise(평균출생수 = mean(전국)) %>% 
  arrange(desc(평균출생수))


# qplot을 이용한 간단 시각화
birth_df %>% 
  group_by(월) %>% 
  summarise(평균출생수 = mean(전국)) %>% 
  qplot(월, 평균출생수,
        geom = "col",
        data = .) + 
  labs(title = "월별 신생아 출생 평균"
      , subtitle = "1997년 ~ 2020년 자료") + 
  theme_bw(base_size = 15)
