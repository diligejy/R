
# 회귀모형의 적합도

x <- c(3, 3, 4, 5, 6, 6, 7, 8, 8, 9)
y <- c(9, 5, 12, 9, 14, 16, 22, 18, 24, 22)

plot(x, y)
cor(x, y)

# 단순 선형 회귀 모형에 적합
fit <- lm(y~x) # ~ : 회귀시킨다는 의미
summary(fit)

# 각 관측치의 잔차를 알고 싶을 때
resid(fit)
rr <- y - fitted(fit) ; rr

# 회귀계수를 알고 싶을 때
coef(fit)
fit$cofficients

# 회귀계수의 신뢰
confint(fit, level = 0.95)

# 회귀 모형의 ANOVA(분산분석)
anova(fit)

# 산점도와 회귀직선을 동시에 그리고 싶을 때
plot(x, y)
abline(fit)
