require(XML)
require(RCurl)
require(maptools)
require(RColorBrewer)
require(rgdal)
library(reshape2)
library(plyr)
source("plot_util.R")
#sudo apt-get install libgeos-dev libgdal-dev libgdal1-dev libproj-dev
#install.packages('rgeos')
#install.packages('rgdal')

##
## Sagres Data Setup
##
names(sagres_data)[1] = "id"
names(sagres_data)[2] = "UF"
names(sagres_data)[3] = "UFO"
names(sagres_data)[4] = "MUNICIPIO"
names(sagres_data)[5] = "EXERCICIO"

sagres_data$MUNICIPIO <- toupper(sagres_data$MUNICIPIO)
sagres_data$MUNICIPIO <- as.factor(sagres_data$MUNICIPIO)
sagres_data$UFO <- as.factor(sagres_data$UFO)
summary(sagres_data)

#servidor mpor muncipio/estado
wsd_uf <- ddply(sagres_data,~UF,summarise,numero_de_servidores=length(unique(id)))
wsd_ufo <- ddply(sagres_data,~UFO,summarise,numero_de_servidores=length(unique(id)))
wsd_mun <- ddply(sagres_data,~MUNICIPIO,summarise,numero_de_servidores=length(unique(id)))
wsd_ufm <- ddply(sagres_data,~ UF + UFO + MUNICIPIO,summarise,numero_de_servidores=length(unique(id)))


# ajustes p plotagem

w <- wsd_ufo
# categoria por numero de servidres
w$cat = cut(w$numero_de_servidores, breaks=c(0,99,100,500,1000,5000,50000),
                          labels=c('até 99','+ 100', '+ 500', '+ 1000', 'até 5000' , "+ 5000" ))
names(w)[1] = "UF"

# Selecionamos algumas cores de uma paleta de cores do pacote RColorBrewer
paletaDeCores = brewer.pal(9, 'OrRd')
paletaDeCores = paletaDeCores[-c(3,6,8)]
# Agora fazemos um pareamento entre as faixas da variável sobre as categorias as cores:
coresDasCategorias = data.frame(cat=levels(w$cat), Cores=paletaDeCores)
w = merge(w, coresDasCategorias)


#w <- wsd_ufm
#w$UF <- as.character(w$UF)
#w$UFO <- as.character(w$UFO)
#z = w[w$UFO != w$UF,]


## Estados

mapE = readShapePoly("scratch/GIS/estados/estados_2010.shp")
plot(mapE)
mapEData = attr(mapE, 'data')
mapEData$Index = row.names(mapEData)
names(mapEData)[3] = "UF"

#merge data
mapaData = merge(mapEData, sagres_data, by="UF")
# apos arrumar os dados
mapaData = merge(mapEData, w, by="UF")

#colocar de volta a informacao no mapa
attr(mapE, 'data') = mapaData


# Configurando tela (reduzindo as margens da figura)
#parDefault = par(no.readonly = T)
#par(mar=rep(5,5))
#dev.off()
#layout(matrix(c(1,2),nrow=2),widths= c(1,1), heights=c(10,2))

# Plotando mapa
#dev.off()
#graphics.off()

par(mfcol=c(2,1), oma=c(0,0,0,0), mar=c(0,0,0,0), tcl=-0.1, mgp=c(0,0,0))

plot(mapE, col=as.character(mapaData$Cores)) +
  plot(1,1,pch=NA, axes=F) + 
    legend(x='center', legend=rev(levels(mapaData$cat)),
       box.lty=0, fill=rev(paletaDeCores),cex=.8, ncol=2,
       title='servidores espalhados pelo brasil\n2010. Em bilhões de reais:')



## Municipios
mapM = rgdal::readOGR("scratch/GIS/municipios/Municipios.shp")
plot(mapM)

mapMData = attr(mapM, 'data')
mapMData$Index = row.names(mapMData)
names(mapMData)[5]="MUNICIPIO"
mapMData$MUNICIPIO <- toupper(mapMData$MUNICIPIO)

m <- wsd_mun
# categoria por numero de servidres
m$cat = cut(m$numero_de_servidores, breaks=c(0,99,100,500,1000,5000,50000),
            labels=c('até 99','+ 100', '+ 500', '+ 1000', 'até 5000' , "+ 5000" ))


# Selecionamos algumas cores de uma paleta de cores do pacote RColorBrewer
paletaDeCores = brewer.pal(9, 'OrRd')
paletaDeCores = paletaDeCores[-c(3,6,8)]
coresDasCategorias = data.frame(cat=levels(m$cat), Cores=paletaDeCores)

m = merge(m, coresDasCategorias)
mapMData = attr(mapM, 'data')
mapMData$Index = row.names(mapMData)
mapMData = merge(mapMData, w, by="UF")

#colocar de volta a informacao no mapa
attr(mapM, 'data') = mapMData

plot(mapM, col=as.character(mapaData$Cores)) +
  plot(1,1,pch=NA, axes=F) + 
  legend(x='center', legend=rev(levels(mapaData$cat)),
         box.lty=0, fill=rev(paletaDeCores),cex=.8, ncol=2,
         title='servidores espalhados pelo brasil\n2010. Em bilhões de reais:')