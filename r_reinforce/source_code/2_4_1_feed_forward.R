## relu 함수
relu <- function(x) {
  ifelse(x> 0 , x, 0)
}

## sigmoid 함수
sigm <- function(x){
  1/(1+exp(-x))
}
