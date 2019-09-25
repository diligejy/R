
# 거래소 데이터 정리

down_sector = read.csv('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/krx_sector.csv', row.names = 1, 
                       stringsAsFactors = FALSE)
down_ind = read.csv('C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/krx_ind.csv', row.names = 1,
                    stringsAsFactors = FALSE)

print(down_sector)
print(down_ind)

intersect(names(down_sector), names(down_ind))


setdiff(down_sector[, '종목명'], down_ind[, '종목명'])
# 공통적으로 없는 종목은 선박펀드, 광물펀드, 해외종목 등 일반적 종목이 아니므로 제외하는 게 좋음

KOR_ticker = merge(down_sector, down_ind,
                   by = intersect(names(down_sector),
                                  names(down_ind)),
                   all = FALSE)

KOR_ticker = KOR_ticker[order(-KOR_ticker['시가총액.원.']), ]
print(head(KOR_ticker))

library(stringr)

KOR_ticker[grepl('스팩', KOR_ticker[, '종목명']), '종목명']

KOR_ticker[str_sub(KOR_ticker[, '종목명'], -1, -1) == '우', '종목명']

KOR_ticker[str_sub(KOR_ticker[, '종목명'], -2, -1) == '우B', '종목명']

KOR_ticker[str_sub(KOR_ticker[, '종목명'], -2, -1) == '우C', '종목명'] 

KOR_ticker = KOR_ticker[!grepl('스팩', KOR_ticker[, '종목명']), ]
KOR_ticker = KOR_ticker[str_sub(KOR_ticker[, '종목명'], -1, -1) != '우', ]
KOR_ticker = KOR_ticker[str_sub(KOR_ticker[, '종목명'], -2, -1) != '우B', ]
KOR_ticker = KOR_ticker[str_sub(KOR_ticker[, '종목명'], -2, -1) != '우C', ]


rownames(KOR_ticker) = NULL
print(KOR_ticker)

write.csv(KOR_ticker, 'C:/Users/jinyoung/Desktop/R_finance/R_Quant_Portfolio/data/KOR_ticker.csv')
