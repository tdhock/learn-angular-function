source("tikz.R")

load("nodes2.features.RData")

set <- nodes2.features$angles.sep
set$y <- ifelse(set$label=="good",1,-1)

p <- ggplot(set)+
  geom_bar(aes(angle))+
  facet_grid(y~.,labeller=function(var,val){
    sprintf("label $y_i=%d$",val)
  })+
  xlab("angular feature $x_i$")

tikz("figure-features.tex", h=4, w=6)
print(p)
dev.off()
