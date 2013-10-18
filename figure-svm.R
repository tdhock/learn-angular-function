works_with_R("3.0.1",quadmod="2013.8.23")
 
source("tikz.R")

load("nodes2.features.RData")
set <- nodes2.features$angles.sep
all.x <- set$angle
all.y <- ifelse(set$label=="good",1,-1)
sets <- list(all=TRUE,not.highest=all.x<1,not.lowest=all.x>-1)
fun.df <- data.frame()
point.df <- data.frame()
for(set.name in names(sets)){
  train <- sets[[set.name]]
  x <- all.x[train]
  y <- all.y[train]
  point.df <- rbind(point.df, data.frame(set.name, angle=x, score=y))
  N <- length(x)
  m <- -pi/2
  M <- pi/2
  size <- M-m

  distance.funs <- list(euclidean=function(x,y){
    abs(x-y)
  },angular=function(x,y){
    xp <- ifelse(x-y>size/2, x-size, x)
    yp <- ifelse(y-x>size/2, y-size, y)
    abs(xp-yp)
  })

  for(distance.type in names(distance.funs)){
    d.fun <- distance.funs[[distance.type]]
    K <- matrix(NA, N, N)
    k.fun <- function(y)exp(-1*d.fun(y, x))
    for(i in 1:N){
      K[i,] <- k.fun(x[i])
    }
    ## kernelized primal hard margin SVM.
    vars <- make.ids(alpha=N, beta=1)
    constraints <- list()
    for(i in 1:N){
      const <- with(vars,{
        (alpha*K[i,] + beta)*y[i] >= 1
      })
      constraints <- c(constraints,list(const))
    }
    n.vars <- length(unlist(vars))
    d <- rep(0, n.vars)
    D <- diag(n.vars)/1e6
    D[vars$alpha, vars$alpha] <- K
    sol <- run.quadprog(vars, D, d, constraints)
    angle <- seq(m, M, l=100)
    score <- sapply(angle, function(x.test){
      sum(k.fun(x.test)*sol$alpha) + sol$beta
    })
    fun.df <- rbind(fun.df, {
      data.frame(angle, score, distance.type, problem="primal", set.name)
    })

    ## kernelized dual hard margin SVM.
    ## vars <- make.ids(alpha=N)
    ## constraints <- list(sum(vars$alpha) == 0)
    ## for(i in 1:N){
    ##   const <- sum(vars$alpha[i])*y[i] >= 0
    ##   constraints <- c(constraints,list(const))
    ## }
    ## sol <- run.quadprog(vars, K, y, constraints)
    ## score <- sapply(angle, function(x.test){
    ##   sum(k.fun(x.test)*sol$alpha) + sol$beta
    ## })
    ## fun.df <- rbind(fun.df, {
    ##   data.frame(angle, score, distance.type, problem="dual")
    ## })
  }
}
library(grid)
p <- ggplot(,aes(angle, score))+
  geom_line(aes(group=distance.type,colour=distance.type, size=distance.type),
            data=fun.df)+
  scale_size_manual(values=c(euclidean=2,angular=1))+
  facet_grid(set.name~.)+
  geom_point(data=point.df)+
  theme_bw()+
  theme(panel.margin=unit(0,"cm"))

tikz("figure-svm.tex", h=4)
print(p)
dev.off()
