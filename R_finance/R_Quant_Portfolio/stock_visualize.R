
library(ggplot2)

ggplot(data_market, aes(x = ROE, y = PBR)) + 
  geom_point()

ggplot(data_market, aes (x = ROE , y = PBR))+
  geom_point() + 
  coord_cartesian(xlim = c(0, 0.30), ylim = c(0, 3))

ggplot(data_market, aes (x = ROE, y = PBR,
                         color = `시장구분`,
                         shape = `시장구분`)) +
  geom_point() +
  geom_smooth(method = 'lm') +
  coord_cartesian(xlim = c(0, 0.30), ylim = c(0, 3))

ggplot(data_market, aes(x = PBR)) + 
  geom_histogram(binwidth = 0.1) +
  coord_cartesian(xlim = c(0, 10))

ggplot(data_market, aes(x = PBR)) +
  geom_histogram(aes(y = ..density..),
                 binwidth = 0.1,
                 color = 'sky blue', fill = 'sky blue') +
  coord_cartesian(xlim = c(0, 10)) +
  geom_density(color = 'red') + 
  geom_vline(aes(xintercept = median(PBR, na.rm = TRUE)),
             color = 'blue') + 
  geom_text(aes(label = median(PBR, na.rm = TRUE),
                x = median(PBR, na.rm = TRUE), y = 0.05),
            col = 'black', size = 6, hjust = -0.5)

ggplot(data_market, aes(x = SEC_NM_KOR, y = PBR)) + 
  geom_boxplot() + 
  coord_flip()

data_market %>%
  filter(!is.na(SEC_NM_KOR)) %>%
  group_by(SEC_NM_KOR) %>%
  summarize(ROE_sector = median(ROE, na.rm = TRUE),
            PBR_sector = median(PBR, na.rm = TRUE)) %>%
  ggplot(aes(x = ROE_sector, y = PBR_sector,
             color = SEC_NM_KOR, label = SEC_NM_KOR)) + 
  geom_point() +
  geom_text(color = 'black', size = 3, vjust = 1.3) + 
  theme(legend.position =  'bottom',
        legend.title = element_blank())

data_market %>%
  group_by(SEC_NM_KOR) %>%
  summarize(n = n()) %>%
  ggplot(aes(x = SEC_NM_KOR, y = n)) + 
  geom_bar(stat = 'identity') + 
  theme_classic()

data_market %>%
  filter(!is.na(SEC_NM_KOR)) %>%
  group_by(SEC_NM_KOR) %>%
  summarize(n = n()) %>%
  ggplot(aes(x = reorder(SEC_NM_KOR, n), y = n, label = n)) +
  geom_bar(stat = 'identity') + 
  geom_text(color = 'black', size = 4, hjust = -0.3) +
  xlab(NULL) + 
  ylab(NULL) + 
  coord_flip() + 
  scale_y_continuous(expand = c(0, 0, 0.1, 0)) + 
  theme_classic()
