library(readr)
library(ggplot2)

##
## Funções
##

#ajustas os valores
fixVal <- function(val) {
  
  a =  strsplit(val, "\\.(?=[^\\.]+$)", perl=TRUE)
  
  if (length(a[[1]]) > 1){
    p <- gsub('\\.','',a[[1]][1])
    return( paste(p,a[[1]][2],sep = ".") )
  }
  
  return(val)
}

##
## Leitura dos dados
##

#Leitura e ajustes dos dados
data <- read.csv2("./data/02-2017.csv",header = TRUE,sep = ',' ,fileEncoding="UTF-8")
#ajustes
data$Remuneração = as.numeric(lapply(as.character(data$Remuneração),fixVal))
data$Total.Vantagens.Pessoais = as.numeric(lapply(as.character(data$Total.Vantagens.Pessoais),fixVal))
data$Total.Vantagens.Transitorias = as.numeric(lapply(as.character(data$Total.Vantagens.Transitorias),fixVal))
data$Terço.de.Férias = as.numeric(lapply(as.character(data$Terço.de.Férias),fixVal))
data$Abono.de.Permanência = as.numeric(lapply(as.character(data$Abono.de.Permanência),fixVal))
data$Total.Bruto =  as.numeric(lapply(as.character(data$Total.Bruto),fixVal))
data$Descontos.Obrigatórios = as.numeric(data$Descontos.Obrigatórios)
data$Total.Líquido = as.numeric(lapply(as.character(data$Total.Líquido),fixVal))

# separacao
func = 'TÉCNICO ADMINISTRATIVO'
tae = data[data$Cargo == func,]
doc = data[data$Cargo != func,]


servidores <- doc

###
### Geral
###

summary(servidores)

#histogram
ggplot(servidores, aes(x=Total.Líquido)) +
  geom_histogram(aes(fill = ..count..), binwidth=500, colour="black", alpha = 0.5) +
  labs(title = "Número de eventos por linguagem") +
  labs(x="") + labs(y="Número de Servidores")

ggplot(servidores, aes(x=Total.Líquido)) +
  geom_histogram(aes(fill = ..count..), binwidth=500, colour="black", alpha = 0.5) +
  facet_wrap(~Vínculo, scales = "free") +
  labs(title = "Número de eventos por linguagem") +
  labs(x="") + labs(y="Número de Servidores")


ggplot(servidores, aes(x=Remuneração)) +
  geom_histogram(aes(fill = ..count..), binwidth=500, colour="black", alpha = 0.5) +
  labs(title = "Número de eventos por linguagem") +
  labs(x="") + labs(y="Número de Servidores")

ggplot(servidores, aes(x=Remuneração)) +
  geom_histogram(aes(fill = ..count..), binwidth=500, colour="black", alpha = 0.5) +
  facet_wrap(~Vínculo, scales = "free") +
  labs(title = "Número de eventos por linguagem") +
  labs(x="") + labs(y="Número de Servidores")

##
## Por vinculo
##
ggplot(na.omit(servidores),aes(x = Vínculo,
               y=Total.Líquido,group=Vínculo,colour=Vínculo) ) + 
  geom_point(alpha = 0.2, position = "jitter" , show.legend = FALSE) +
  geom_boxplot(aes(group=Vínculo), alpha = 0.9) +
  labs(title = "Número de eventos por linguagem") +
  labs(x="") + labs(y="Valores em R$")


ggplot(na.omit(servidores),aes(x = Vínculo,
               y=Remuneração,group=Vínculo,colour=Vínculo) ) + 
  geom_point(alpha = 0.2, position = "jitter" , show.legend = FALSE) +
  geom_boxplot(aes(group=Vínculo), alpha = 0.9) +
  labs(title = "Número de eventos por linguagem") +
  labs(x="") + labs(y="Valores em R$")

##
## Por Lotacao
##

ggplot(na.omit(servidores),aes(x = Lotação,
                               y=Total.Líquido,group=Lotação,colour=Lotação) ) +
  geom_point(alpha = 0.2, position = "jitter" , show.legend = FALSE) +
  geom_boxplot(aes(group=Lotação), alpha = 0.9, show.legend = FALSE) +
  labs(title = "Número de eventos por linguagem") +
  labs(x="") + labs(y="Valores em R$") +
  theme(axis.text.x = element_text(angle = 70, hjust = 1))

##
## Por escolaridade
##

ggplot(na.omit(servidores),aes(x = Escolaridade,
                               y=Remuneração,group=Escolaridade,colour=Escolaridade) ) +
  geom_point(alpha = 0.2, position = "jitter" , show.legend = FALSE) +
  geom_boxplot(aes(group=Escolaridade), alpha = 0.9) +
  labs(title = "Número de eventos por linguagem") +
  labs(x="") + labs(y="Valores em R$") +
  theme(axis.text.x = element_text(angle = 70, hjust = 1))

ggplot(na.omit(servidores),aes(x = Escolaridade,
                               y=Total.Líquido,group=Escolaridade,colour=Escolaridade) ) +
  geom_point(alpha = 0.2, position = "jitter" , show.legend = FALSE) +
  geom_boxplot(aes(group=Escolaridade), alpha = 0.9) +
  labs(title = "Número de eventos por linguagem") +
  labs(x="") + labs(y="Valores em R$") +
  theme(axis.text.x = element_text(angle = 70, hjust = 1))

ggplot(na.omit(servidores),aes(x = Escolaridade,
                               y=Total.Líquido,group=Escolaridade,colour=Escolaridade) ) +
  geom_point(alpha = 0.2, position = "jitter" , show.legend = FALSE) +
  geom_boxplot(aes(group=Escolaridade), alpha = 0.9) +
  facet_wrap(~Vínculo) +
  labs(title = "Número de eventos por linguagem") +
  labs(x="") + labs(y="Valores em R$") +
  theme(axis.text.x = element_text(angle = 70, hjust = 1))

#ggplot(doc,aes(x = Vínculo,
#               y=Total.Líquido,group=Vínculo,colour=Vínculo) ) + 
#  geom_point(alpha = 0.3, position = "jitter" , show.legend = FALSE) +
#  geom_boxplot(aes(group=Vínculo)) + 
#  facet_grid(repository_language~year, scales = "free") +
#  labs(title = "Número de eventos por linguagem") +
#  labs(x="") + labs(y="Eventos em milhares")+
#  theme(axis.text.x = element_text(angle = 70, hjust = 1))

ggplot(create,aes(x=create$quarter,y=events/1e3 )) + geom_bar(stat='identity', fill='lightblue') + 
  labs(title = "Histograma repositórios criados por trimestre") +
  labs(x="Trimestre") + labs(y="Eventos em milhares")+ theme_bw()

