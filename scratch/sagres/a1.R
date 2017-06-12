library(readr)
sagres <- read_delim("~/Public/sagres/TCE-PB-SAGRES-Folha_Pessoal_Esfera_Estadual.txt", 
                     "|", escape_double = FALSE, trim_ws = TRUE , col_types = cols(dt_Admissao = col_date(format = "%d/%m/%Y") ))
sagres$de_poder <- as.factor(sagres$de_poder)
sagres$de_OrgaoLotacao <- as.factor(sagres$de_OrgaoLotacao)
sagres$no_cargo <- as.factor(sagres$no_cargo)
sagres$tp_cargo <- as.factor(sagres$tp_cargo)




sagres17  <- subset(sagre, dt_Admissao > as.Date("2017-03-01") )
sagres17$dt_mesano <- as.Date(paste(sagres17$dt_mesano, "01", sep=""), "%m%Y%d")


sagres[grep("Merc", rownames(sagres)), ]
pge <- sagres17[sagres17$de_OrgaoLotacao=="PROCURADORIA GERAL DO ESTADO",]
pge <- sagres[sagres$de_OrgaoLotacao=="PROCURADORIA GERAL DO ESTADO",]

sagres$dt_mesano
library(dplyr)
 
sagres17$type <- rownames(sagres17$no_Servidor)
filter(sagres17, grepl('THIAGO', type))

sagres17[grepl('THIAGO+', sagres17$no_Servidor),]