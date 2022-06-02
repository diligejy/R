install.packages("fpp3")
install.packages('tidyverse')
library(tidyverse)
library(fpp3)

y <- tsibble(
  year = 2015:2019,
  observation = c(123, 39, 78, 52, 110),
  index = year
)
y

olympic_running

olympic_running$Length %>% unique()
olympic_running$Sex %>% unique()

prison <- readr::read_csv("https://OTexts.com/fpp3/extrafiles/prison_population.csv")
head(prison)


prison %<>% 
  janitor::clean_names() %>% 
  mutate(quarter = yearquarter(date),
         .keep = "unused") %>% 
  as_tsibble(key = state:indigenous,
             index = quarter)
prison

prison %>% 
  filter(state == "ACT", gender == "Female",
         legal =="Remanded", indigenous == "ATSI") %>% 
  autoplot(count) +
  labs(title = "시간에 따른 죄수 인구의 변화",
       y = "죄수 (명)",
       x = "시간 (분기)")
