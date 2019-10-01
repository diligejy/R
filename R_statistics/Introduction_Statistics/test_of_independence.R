
x <- c(5, 5, 3, 7, 15, 23, 17, 17);
cholesterol <- gl(2, 4, labels = c("220미만", "220이상")); cholestrol

bloodpressure <- gl(4, 1, 8, labels = c("127미만", "127~146", "146~166", "166이상"));

table <- xtabs(x ~ cholesterol + bloodpressure); table

chisq.test(table)
