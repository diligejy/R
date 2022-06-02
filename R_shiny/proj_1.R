install.packages("rstudioapi")
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
getwd()

loc <- read.csv('./01_code/sigun_code/sigun_code.csv', fileEncoding = "UTF-8")
loc$code <- as.character(loc$code) # 행정구역명 문자 변환
head(loc, 2)

# 수집기간 설정하기
datelist <- seq(from = as.Date('2021-01-01'), # 시작
                to = as.Date('2021-12-31'), # 종료 
                by = '1 month') # 단위 
datelist <- format(datelist, format='%Y%m') # 형식변환(YYYY-MM-DD => YYYYMM)
datelist[1:3]

# 인증키 입력하기
service_key <- "3tXaYQ1EIQR5AZvu%2B0jKcSYJ83cb%2FZ0gvs3WCNXXbsmUXM7y3TyDbijRs%2BP05Cp%2BJ7l%2BmdnyfFmZPV4qv7VoVg%3D%3D"

# 03-2 요청 목록 생성

# 요청 목록 만들기
url_list <- list() # 빈 리스트 만들기
cnt <- 0 # 반복문의 제어 변수 초깃값 설정 

for (i in 1:nrow(loc)) { # 외부 반복 : 25개 자치구
  for (j in 1:length(datelist)){ # 내부 반복 : 12개월
    cnt <- cnt + 1 # 반복 누적 세기
    #--# 요청 목록 채우기 (25 * 12 = 300)
    url_list[cnt] <- paste0("http://openapi.molit.go.kr:8081/OpenAPI_ToolInstallPackage/service/rest/RTMSOBJSvc/getRTMSDataSvcAptTrade?",
                            "LAWD_CD=", loc[i,1],         # 지역코드
                            "&DEAL_YMD=", datelist[j],    # 수집월
                            "&numOfRows=", 100,           # 한번에 가져올 최대 자료 수
                            "&serviceKey=", service_key)  # 인증키
  }
  Sys.sleep(0.1) # 0.1초간 멈춤 
  msg <- paste0("[", i,"/",nrow(loc), "]  ", loc[i,3], " 의 크롤링 목록이 생성됨 => 총 [", cnt,"] 건") # 알림 메시지
  cat(msg, "\n\n")
}

#---# [3단계: 요청 목록 동작 확인]

#---# [3단계: 요청 목록 동작 확인]
length(url_list)                # 요청목록 갯수 확인
browseURL(paste0(url_list[1]))  # 정상작동 확인(웹브라우저 실행)
