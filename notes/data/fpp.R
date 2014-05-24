library("ggplot2")


myplot <- function(dfx, outf, yrange) {
  
  quartz(type="pdf", file= outf,  width=11, height=6)
  theme_set(theme_bw(base_family="Bitstream Vera Sans Mono", base_size=16))
  
  g = ggplot(data = dfx, aes( x=clients, y = bw)) 
  
  # top
  # g = g + theme(legend.position="top")
  
  g = g + geom_point(size=5)
  g = g + geom_line(size=1.5) 
  
  # g = g + geom_smooth(size=2, se=FALSE)
  g = g + ylab("Bandwidth (MB/s)\n") + xlab("\nNumber of Clients")
  
  # title
  g = g + ggtitle("Max Write Throughput \n(1MB Transfer Size, 30 seconds Stonewall, 16 GB Block Size)\n")
  # xy axis
  # g = g + scale_y_continuous(breaks=seq(0,yrange,3000))
  
  # change Y-axis label distance
  #g = g + theme(axis.title.y = element_text(size = 20, vjust=0.4))
  #g = g + theme(axis.title.x= element_text(size = 20, vjust=-0.3))
  #g = g + theme(axis.title = element_text(size = 10, vjust=0.5))
  
  print(g)
  dev.off()
  
}



args = commandArgs(trailingOnly = TRUE)
print(args)
options( warn= -1)

# read in data

df = read.csv(args[1], comment.char = '#', strip.white=TRUE)
myplot(df, "fpp.pdf", 310000)