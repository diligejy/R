
# R을 이용하여 2차원 평면에서 그림 그리기

data()
faithful

x <- faithful$eruptions
y <- faithful$waiting

plot(x, y)
plot(x, y, xlab = "eruption", ylab = "waiting",
     main = "faithful data", xlim = c(0, 7), ylim = c(30, 100))

x1 <- x[1:136]; x1
x2 <- x[137:272]; x2
y1 <- y[1:136]; y1
y2 <- y[137:272]; y2

plot(c(x1, x2), c(y1, y2), type = "n")
points(x1, y1, col = "red")
points(x2, y2, col = "blue")
abline(lm(y1~x1))
abline(lm(y2~x2))
abline(lm(y~x))

# 다중 선형 회귀 모형
data()
stackloss

y <- stackloss$stack.loss; y
x1 <- stackloss$Air.Flow; x1
x2 <- stackloss$Water.Temp; x2
x3 <- stackloss$Acid.Conc.; x3
X <- cbind(x1, x2, x3); X

pairs(X) # pairwise scatterplot matrix of covariates

stackfit <- lm(y ~ x1 + x2 + x3) # model fitting

plot(stackfit) # 4 basic plots
# - residual vs fitted
# - normarl qqplot
# - standardized residual vs fitted
# - Cook's distance

summary(stackfit) # basic estimation results

anova(stackfit) # analysis of variance table

deviance(stackfit) # RSS

deviance(lm(y~l)) # SST

residuals(stackfit)

vcov(stackfit)

coef(stackfit)

step(stackfit)