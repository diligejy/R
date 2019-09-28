
# 0부터 9까지의 정수를 균일분포로 2,500개 생성
# runif = r andom + unif orm
# floor 무조건 버림

x = floor(runif(2500, 0, 10)); x

 
hist(x)
mean(x) # E(X) = 4.5와 유사
sd(x) # s.d.(X) = 2.87과 유사

# 2,500개의 정수를 크기가 5인 벡터 500개를 생성
y = array(x, c(500, 5)) ; y

# 크기 5인 표본에서 표본평균을 구하여 500개의 표본 평균을 생성
xbar = apply(y, 1, mean) ; xbar

hist(xbar)
mean(xbar)
sd(xbar)
