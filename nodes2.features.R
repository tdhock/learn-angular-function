## This file is for calculation
## the features of the data set
## which are, the distance and the angle.

load("nodes2.RData")

nodes2.features <- list()
for(set.name in names(nodes2) ){
  ## Call out for calculation 
  dataset <- nodes2[[set.name]]

  for(layout.i in 1:nrow(dataset)){
    layout <- dataset[layout.i,]
    xy <- layout$nodes
    d <- xy[1,]-xy[2,]
    dy <- xy[2,"y"]-xy[1,"y"]
    dx <- xy[2,"x"]-xy[1,"x"]
    features <-
      data.frame(label=layout$label,
                 distance=sqrt(sum(d^2)),
                 angle=atan(dy/dx))
    nodes2.features[[set.name]] <-
      rbind(nodes2.features[[set.name]], features)
  }
  ## scale data to mean 0 and sd 1.
  ##nodes2.features[[set.name]][,-1] <-
  ##  scale(nodes2.features[[set.name]][,-1])
}

save(nodes2.features, file="nodes2.features.RData")
