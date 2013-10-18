source("tikz.R")

load("nodes2.features.RData")
set <- nodes2.features$angles.sep
m <- -pi/2
M <- pi/2
size <- M-m
ref <- -1
x <- c(set$angle, ref, ref+size/2)
angle <- c(x, m, M)

distance.funs <- list(euclidean=function(x,y){
  abs(x-y)
},angular=function(x,y){
  xp <- ifelse(x-y>size/2, x-size, x)
  yp <- ifelse(y-x>size/2, y-size, y)
  abs(xp-yp)
})

dot.df <- data.frame()
for(distance.type in names(distance.funs)){
  fun <- distance.funs[[distance.type]]
  distance <- fun(angle, ref)
  dot.df <- rbind(dot.df, data.frame(distance.type, angle, distance))
}

p <-
  ggplot(dot.df,aes(angle, distance, colour=distance.type, size=distance.type))+
  ##geom_point()+
  geom_line()+
  geom_hline(yintercept=ref-m)+
  scale_y_continuous(sprintf("$d(x, %s)=$distance to %s",
                             as.character(ref),as.character(ref)))+
  scale_size_manual(values=c(euclidean=2,angular=1))

tikz("figure-distance-funs.tex",h=3)
print(p)
dev.off()
