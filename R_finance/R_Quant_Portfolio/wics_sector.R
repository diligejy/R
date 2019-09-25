
library(jsonlite)

sector_code = c('G25', 'G35', 'G50', 'G40', 'G10',
                'G20', 'G55', 'G30', 'G15', 'G45')

data_sector = list()
for (i in sector_code){
  url = paste0('http://www.wiseindex.com/Index/GetIndexComponets?ceil_yn=0&dt=20190924&sec_cd=', i)

  data = fromJSON(url)
  data = data$list

  data_sector[[i]] = data

  Sys.sleep((1))
}


data_sector = do.call(rbind, data_sector)

print(data_sector)

write.csv(data_sector, 'C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_sector.csv')
