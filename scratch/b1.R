library(readr)
library(ggplot2)
source('file_util.R', encoding="utf-8")
source('plot_Complex.R', encoding="utf-8")



files <- list.files(path = 'data/', pattern = '.csv')

fullData <- read_data(paste("data/",files[1],sep=""))
mes <- head(strsplit(files[1],"-")[[1]],1)
ano <- gsub('.csv','',tail(strsplit(files[1],"-")[[1]],1))

fullData["mes"] <- as.integer(mes)
fullData["ano"] <- as.integer(ano)

for (name in files[2:length(files)]) {

  input <- paste("data/",name,sep="")
  tr <- read_data(input)
  mes <- head(strsplit(name,"-")[[1]],1)
  ano <- gsub('.csv','',tail(strsplit(name,"-")[[1]],1))
  
  tr["mes"] <- as.integer(mes)
  tr["ano"] <- as.integer(ano)
  
  fullData <- rbind(fullData,tr)
  print(name)
}

#245910 registros
#mydata[!complete.cases(mydata),]
#a <- fullData[ fullData$ano == 2017,]

library(reshape2)
library(plyr)


## fazer por Lotação e Vínculo
#ano
meltData_a <- melt(fullData[complete.cases(fullData$Total.Bruto),], id=c("ano") , measure.vars = c("Total.Bruto"))
wd_a <- dcast(meltData_a, ano ~ variable , sum)
#servidore/ano
wdQS_a <- ddply(fullData,~ano,summarise,numero_de_servidores=length(unique(Matrícula)))

plot_QuantidadeServidoresGastoBrutoAnual(fullData)

# mes ano
meltData_ma <- melt(fullData[complete.cases(fullData$Total.Bruto),], id=c("mes", "ano") , measure.vars = c("Total.Bruto"))
wd_ma <- dcast(meltData_ma, mes + ano ~ variable , sum)



ggplot(wd_ma, aes(x=interaction(mes,ano),y=Total.Bruto) ) +
  geom_bar(stat="identity") + 
    labs( title = "X" ) +
    labs(x="Remuneração em R$") + labs(y="Número de Servidores") + 
    theme(axis.text.x = element_text(angle = 70, hjust = 1))


