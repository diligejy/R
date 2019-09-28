
# 독립 이분포 검정

A <-c(79.98, 80.04, 80.02, 80.04, 80.03, 80.03, 80.04,79.97,
      80.05, 80.03, 80.02, 80.00, 80.00); A

length(A)

B <- c(80.02, 79.94, 79.98, 79.97, 79.97, 80.03, 79.95, 79.97)

length(B)

boxplot(A, B)

# two sample t-test (독립성, 정규성, 등분산성)

t.test(A, B, var.equal = T)

# assuming unequal variances 
t.test(A, B)

t.test(A, B, var.equal = F)
