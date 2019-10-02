
# solve.QP() 함수를 이용한 최적화
Dmat = covmat
dvec = rep(0, 10)
Amat = t(rbind(sqrt(diag(covmat)), diag(10)))
bvec = c(1, rep(0, 10))
meq = 1

result = solve.QP(Dmat, dvec, Amat, bvec, meq)

w = result$solution %>%
  round(., 4) %>%
  setNames(colnames(rets))
print(w)

data.frame(w) %>%
  ggplot(aes(x = factor(rownames(.), levels = rownames(.)),
             y = w)) + 
  geom_col() +
  geom_col() +
  xlab(NULL) + ylab(NULL)

# optimalPortfolio() 함수를 이용한 최적화

w = optimalPortfolio(covmat, control = list(type = 'maxdiv',
                                            constraint = 'lo')) %>%
  round(., 4)

print(w)


# 최소 및 최대 투자비중 제약조건
Dmat = covmat
dvec = rep(0, 10)
Alb = -rep(0.05, 10) %*% matrix(1, 1, 10) + diag(10)
Aub = rep(0.20, 10) %*% matrix(1, 1, 10) - diag(10)

Amat = t(rbind(sqrt(diag(covmat)), Alb, Aub))
bvec = c(1, rep(0, 10), rep(0, 10))
meq = 1

result = solve.QP(Dmat, dvec, Amat, bvec, meq)

w = result$solution 
w = (w / sum(w)) %>%
  round(., 4) %>%
  setNames(colnames(rets))

print(w)

