## Parse several occurances of pattern from each of several strings
## using (named) capturing regular expressions, returning a list of
## matrices (with column names).
str_match_all_perl <- function(string,pattern){
  stopifnot(is.character(string))
  stopifnot(is.character(pattern))
  stopifnot(length(pattern)==1)
  parsed <- gregexpr(pattern,string,perl=TRUE)
  lapply(seq_along(parsed),function(i){
    r <- parsed[[i]]
    starts <- attr(r,"capture.start")
    if(r[1]==-1)return(matrix(nrow=0,ncol=1+ncol(starts)))
    names <- attr(r,"capture.names")
    lengths <- attr(r,"capture.length")
    full <- substring(string[i],r,r+attr(r,"match.length")-1)
    subs <- substring(string[i],starts,starts+lengths-1)
    m <- matrix(c(full,subs),ncol=length(names)+1)
    colnames(m) <- c("",names)
    m
  })
}

## extract nodes from xml. --- From Toby ---
## Pattern for parsing from the graphml file.
node.pattern <- paste('node id="',
                      '(?<node>[^"]+)',
                      ".*?",
                      '"x">',
                      '(?<x>[^<]+)',
                      ".*?",
                      '"y">',
                      '(?<y>[^<]+)',
                      sep="")

## Import file and parse xml.

classes <- c("good","bad")

nodes2 <- list()
folders <- Sys.glob(file.path("nodes2", "*"))
## Iteration at every folder 
for(folder in folders){
  
  dataname <- sub(".*/", "", folder)
  nodetable <- data.frame()
  edgetable <- data.frame()
  
  for(c.class in classes){
    
    c.path <- file.path(folder, c.class)
    ## Only .graphml
    gml.files <- Sys.glob(file.path(c.path,"*.graphml"))
    for(filename.i in seq_along(gml.files)){
      filename <- gml.files[filename.i]
    
      Mlines <- readLines(filename)
      xml <- paste(Mlines, collapse="")
    
      ## Data frame for positions of nodes.
      ## Construct the node table.
    
      node.matrix.str <- str_match_all_perl(xml,node.pattern)[[1]]
      nodes <- cbind(x=as.numeric(node.matrix.str[,"x"]),
                     y=as.numeric(node.matrix.str[,"y"]))
    
      ## Checking whether theres something wrong with the files.
      if(nrow(nodes)!=2){
        stop("Not 2 nodes!!!!!!!!!!!")
      }
    
      L <- list(label=c.class, nodes=nodes)
      nodes2[[dataname]] <- rbind(nodes2[[dataname]], L)
    }
  }
}

## Save the big list to .RDdata 
save(nodes2, file="nodes2.RData")

