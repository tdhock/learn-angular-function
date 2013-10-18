source("tikz.R")

load("nodes2.RData")
load("nodes2.features.RData")

set.name <- "angles.sep"
layouts <- nodes2[[set.name]]
features <- nodes2.features[[set.name]]

seg.df <- data.frame()
point.df <- data.frame()
lab.df <- data.frame()
for(i in 1:nrow(features)){
  r <- layouts[i,]
  f <- features[i,]
  label <- sprintf("$%.2f\\pi$ id=%d",f$angle/pi, layout=i)
  point.df <- rbind(point.df,{
    data.frame(label, r$nodes)
  })
  seg.df <- rbind(seg.df,{
    data.frame(label,t(c(s=r$nodes[1,],e=r$nodes[2,])))
  })
}

library(grid)
p <- ggplot()+
  geom_point(aes(x, y), data=point.df)+
  geom_segment(aes(s.x, s.y, xend=e.x, yend=e.y), data=seg.df)+
  facet_wrap("label")+
  theme_bw()+
  theme(panel.margin=unit(0,"cm"))

tikz("figure-angles-layouts.tex",h=4)
print(p)
dev.off()
