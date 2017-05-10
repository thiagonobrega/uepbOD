fixVal <- function(val) {
  
  a =  strsplit(val, "\\.(?=[^\\.]+$)", perl=TRUE)
  
  if (length(a[[1]]) > 1){
    p <- gsub('\\.','',a[[1]][1])
    return( paste(p,a[[1]][2],sep = ".") )
  }
  
  return(val)
}

convertCsv <- function(dir,lfile){
  file <- paste(dir,lfile,sep = "")
  data <- read.csv2(file,header = TRUE,sep = ',')
  
  print(file)
  
  data$Remuneração = as.numeric(lapply(as.character(data$Remuneração),fixVal))
  data$Total.Vantagens.Pessoais = as.numeric(lapply(as.character(data$Total.Vantagens.Pessoais),fixVal))
  data$Total.Vantagens.Transitorias = as.numeric(lapply(as.character(data$Total.Vantagens.Transitorias),fixVal))
  data$Terço.de.Férias = as.numeric(lapply(as.character(data$Terço.de.Férias),fixVal))
  data$Abono.de.Permanência = as.numeric(lapply(as.character(data$Abono.de.Permanência),fixVal))
  data$Total.Bruto =  as.numeric(lapply(as.character(data$Total.Bruto),fixVal))
  data$Descontos.Obrigatórios = as.numeric(data$Descontos.Obrigatórios)
  data$Total.Líquido = as.numeric(lapply(as.character(data$Total.Líquido),fixVal))
  #drops <- c("X")
  #data = data[ , !(names(data) %in% drops)]
  return(data)
}

data_dir = "./data/"
temp <- list.files(data_dir,pattern="*.csv")

data <- read.csv2("./data/01-2010.csv",header = TRUE,sep = ',' ,encoding = "UTF-8")
data$

data = convertCsv(data_dir,temp[[1]])

for (i in 2:length(temp)){
#for (i in 1:length(temp)) assign(temp[i], read.csv(temp[i]))
  d1 = convertCsv(data_dir,temp[[1]])
  data <- rbind(data, d1)
#  assign(temp[i], read.csv(temp[i]))
}

data$X
write.csv2(data,"./data/all.csv",sep=";")
a <- read.csv2("./data/all.csv",header = TRUE,sep = ";")
combined <- rbind(tae, doc)