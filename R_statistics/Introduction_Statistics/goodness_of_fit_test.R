
# 적합도 검정

x <- matrix(c(773, 231, 238, 59), nrow = 1, ncol = 4); x
chi <- chisq.test(x, p = c(9/16, 3/16, 3/16, 1/16)); chi

chi$observed
chi$expected
chi$residuals

