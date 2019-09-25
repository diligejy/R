path<- "C:/Users/jinyoung/Desktop/R_Youtube/airim/data"  # 여기는 여러분의 데이터가 담긴 주소를 써주세요 !!
setwd(path)                              # 주소를 셋팅합니다!
getwd()                                  # 주소가 잘 셋팅되었는지 확인하시고 싶으시다면 !

Making_Data<-read.csv("processing_data_example.csv",header = TRUE)          # 여러분의 데이터가 담긴 파일이름을 넣어주세요!
Making_Data3<-Making_Data[Making_Data$prod_no == "45231-3B610",-1] # 그룹이 몇개 있는데 그중 45231-3B610 이라는                                                                         이름을 가진 그룹을 사용할 꺼에요 !
boxplot(Making_Data3$c_thickness)                                  #  4분위수 박스플롯 그리기!

data<-Making_Data3$c_thickness                                     # 데이터의 종속변수를 data라는 명칭으로 저장!
which(data < fivenum(data)[2] - 1.5 * IQR(data))                   # 4분위수를 수치로 확인할수 있는 명령어 입니다!
which(data > fivenum(data)[4] + 1.5 * IQR(data))                   # 여기도 마찬가지 입니다~

m<- lm(Making_Data3$c_thickness ~., data = Making_Data3)  # 회귀분석을 실시합니다~ 종속변수는 c_thickness                                                                      독립변수는 나머지 변수 전부를 사용합니다! 
rstandard(m)                                              # 분석 실시!

plot(rstandard(m),main = "처음")                 # 회귀분석한 결과를 그래프로 그려봅니다!



install.packages("car")                                      
library(car)

outlierTest(m)                                          #아웃라이어를 찾는 아주 간편한 함수 입니다!

m<-lm(Making_Data3$c_thickness ~., data = Making_Data3) #이번엔 쿡의 거리를 활용해서 이상치를 찾을 겁니다!
plot(m)                                                 #plot()을 사용해서 네번 enter를 눌러주세요!
                                                        # 그럼 쿡의거리를 활용한 시각화 자료가 나타납니다!

cooks<- cooks.distance(m)                               # 또다른 쿡의 거리 활용방법!
plot(cooks, pch="★",cex=1.5,main = "두번째")     # 시각화를 실시하기위해 그래프 를 그려봅니다!
text(x=1:length(cooks),y=cooks,labels = ifelse(cooks > 4/nrow(Making_Data3),   #이건 그래프 설정방법입니다~
                                               names(cooks),""),col = "red")

outlier <- names(cooks)[(cooks > 4/nrow(Making_Data3))] #쿡의 거리를 활용한 이상치 탐색 결과를 outlier변수에 할당~
outlier                                                 # 이상치로 구분된 아이들을 찾아냅니다!

outlier_data<-Making_Data3[rownames(Making_Data3) %in% outlier,]  #이상치로 구분된 아이들을 자세히 확인!


