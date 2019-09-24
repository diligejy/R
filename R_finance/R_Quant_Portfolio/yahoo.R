

library(quantmod)

getSymbols('AAPL')

head(AAPL)

chart_Series(Ad(AAPL))

data = getSymbols('AAPL',
                  from = '2000-01-01', 
                  auto.assign = FALSE)
tail(data)

# 페이스북, 엔비디아 주가 불러오기
ticker = c('FB', 'NVDA') 
getSymbols(ticker)

head(FB)

head(NVDA)

# 국내 종목 주가 불러오기

getSymbols('005930.KS',
           from = '2000-01-01', to = '2019-09-24')

tail(Ad(`005930.KS`))

# 국내 종목은 종종 수정주가에 오류가 발생하는 경우가 많아서 
# 배당이 반영된 값보다는 단순 종가(Close) 데이터를 사용하기를 권장

tail(Cl(`005930.KS`))

# 이번엔 셀트코인 해보자. 코스닥이니까 KQ

getSymbols('068760.KQ',
           from = '2000-01-01', to = '2019-09-24')

tail(Cl(`068760.KQ`))

# FRED 데이터 다운로드

getSymbols('DGS10', src = 'FRED')
chart_Series(DGS10)

# FRED에서 환율 데이터 가져오기
getSymbols('DEXKOUS', src='FRED')
tail(DEXKOUS)

chart_Series(DEXKOUS)
