x <- matrix(c(31, 17, 109, 122), nc =2); x
chi <- chisq.test(x,correct = FALSE); chi

chi$observed
chi$expected
sum(chi$observed - chi$expected)^2/chi$expected
chi$statistic


# 분할표
x <- c(31, 17, 109, 122)

group <- gl(2, 1, 4, labels = c("case", "control")); group

infection <- gl(2, 2, labels = c("yes", "no")); infection

table <- xtabs(x~group+infection); table

chisq.test(table, correct = FALSE)