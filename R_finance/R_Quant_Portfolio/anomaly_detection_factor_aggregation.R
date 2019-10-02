
library(magrittr)
library(ggplot2)

KOR_value = read.csv('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_value.csv', row.names = 1,
                     stringsAsFactors = FALSE)

max(KOR_value$PBR, na.rm = TRUE)

KOR_value %>%
  ggplot(aes(x = PBR)) + 
  geom_histogram(binwidth =  0.1)

# Trim : 이상치 데이터 삭제

library(dplyr)

value_trim = KOR_value %>%
  select(PBR) %>%
  mutate(PBR = ifelse(percent_rank(PBR) > 0.99, NA, PBR),
         PBR = ifelse(percent_rank(PBR) < 0.01, NA, PBR))

value_trim %>%
  ggplot(aes(x = PBR)) + 
  geom_histogram(binwidth =  0.1)

# 평균이나 분산같이 통곗값을 구하는 과정에서는 이상치 데이터를 제거하는 것이 바람직할 수 있습니다. 
# 그러나 팩터를 이용해 포트폴리오를 구하는 과정에서 해당 방법은 잘 사용되지 않습니다. 
# 데이터의 손실이 발생하게 되며, 제거된 종목 중 정말로 좋은 종목이 있을 수도 있기 때문입니다.

# 윈저라이징(Winsorizing): 이상치 데이터 대체

# 포트폴리오 구성에서는 일반적으로 이상치 데이터를 다른 데이터로 대체하는 윈저라이징 방법이 사용됩니다. 
# 예를 들어 상위 99%를 초과하는 데이터는 99% 값으로 대체하며, 하위 1% 미만의 데이터는 1% 데이터로 대체합니다. 
# 즉, 좌우로 울타리를 쳐놓고 해당 범위를 넘어가는 값을 강제로 울타리에 맞춰줍니다.

value_winsor = KOR_value %>%
  select(PBR) %>%
  mutate(PBR = ifelse(percent_rank(PBR) > 0.99,
                      quantile(., 0.99, na.rm = TRUE), PBR),
         PBR = ifelse(percent_rank(PBR) < 0.01, 
                      quantile(., 0.01, na.rm = TRUE), PBR))

value_winsor %>%
  ggplot(aes(x = PBR)) + 
  geom_histogram(binwidth = 0.1)

# 팩터의 결합방법

library(tidyr)

KOR_value %>%
  mutate_all(list(~min_rank(.))) %>%
  gather() %>%
  ggplot(aes(x = value)) + 
  geom_histogram() + 
  facet_wrap(. ~ key)

# 랭킹을 구한 뒤 Z-Score로 정규화
KOR_value %>%
  mutate_all(list(~min_rank(.))) %>%
  mutate_all(list(~scale(.))) %>%
  gather() %>%
  ggplot(aes(x = value)) +
  geom_histogram() +
  facet_wrap(. ~ key)
