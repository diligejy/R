# 데이터 불러오기
setwd('./R/kosis/')

library(tidyverse)

data_c_2020 <- read.csv('./2020_연간자료_C형_20220821_69301.csv')
guess_encoding("./2020_연간자료_C형_20220821_83393.csv")

data_c_2020 <- read_csv('./2020_연간자료_C형_20220821_69301.csv',
                          locale=locale(encoding="EUC-KR"))
data_c_2021 <- read_csv('./2021_연간자료_C형_20220821_69301.csv',
                        locale=locale(encoding="EUC-KR"))

dim(data_c_2020)
dim(data_c_2021)

glimpse(data_c_2020)
glimpse(data_c_2021)

# 데이터 합치기 
data_c_2020 <- data_c_2020 %>% mutate(년도 = 2020)
data_c_2021 <- data_c_2021 %>% mutate(년도 = 2021)
edu_df <- bind_rows(data_c_2020, data_c_2021)
glimpse(edu_df)
dim(edu_df)

edu_df$지역구분코드 %>% unique()
edu_df$학교급구분코드 %>% unique()
edu_df$가중값

# 표본조사 데이터의 가중값
# 표본이 뽑힐 확률의 역수를 의미
# (표본이 모집단에서 차지하는 정도로 이해)

# 예시
# 1번 표본값 10만, 가중값 10
# 2번 표본값 25만, 가중값 50
# (10 + 25) 처럼 표본에 대응되는 값만 가지고 계산 X!

# 10가구, 50가구
# (10 * 10 + 25 * 50)

info_df <- edu_df %>% 
  mutate(학교급구분코드 = 
           case_when(
             학교급구분코드 == 1 ~ "초등학교",
             학교급구분코드 == 2 ~ "중학교",
             TRUE ~ "고등학교")) %>% 
  mutate(조정값 = 사교육비총비용 * 가중값) %>% 
  group_by(학교급구분코드, 년도) %>% 
  summarise(총비용 = sum(조정값) / 10^8) %>% 
  ungroup()

info_df

info_df2 <- info_df %>% 
  pivot_wider(
    id_cols = 학교급구분코드,
    names_from = 년도,
    values_from = 총비용,
    names_glue = "{년도}년")

info_df2

library(janitor)
library(scales)

info_df2 <- info_df2 %>% 
  rename(학교구분 = 학교급구분코드) %>% 
  adorn_totals("row") %>% 
  mutate(증감율 = (`2021년` / `2020년`)
         , 증감율 = percent(증감율 - 1))

info_df2
