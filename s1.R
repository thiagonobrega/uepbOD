data_dir = "C:/Users/Thiago/Desktop/"

temp <- list.files(data_dir,pattern="*.csv")
val = temp[[1]]

#for (i in 1:length(temp)) assign(temp[i], read.csv(temp[i]))
ys = 2016
ye = 2017
me = 02

gerarLista <- function(ys,me,ye) {
  
  r = c()
  
  for (y in ys:ye){
    
    meses = c()
    
    if (y == ye){
      for (m in 1:me){
        meses <- c(meses,paste(m,y,sep = "-"))
      }
    } else {
      for (m in 1:13){
        meses <- c(meses,paste(m,y,sep = "-"))
      }
    }
    
    r[[as.character(y)]] <- meses
    
  }
    
  
  return(r)
}
