library(ggplot2)


salaryHistogramRemuneracao <- function(data,classe){
  if ( missing(classe) ){
    titulo <- "Histograma dos Salários"
  } else {
    titulo <- paste("Histograma dos Salários dos",classe)
  }
  
  ggplot(data, aes(x=Remuneração)) +
    geom_histogram(aes(fill = ..count..), binwidth=500, colour="black", alpha = 0.5) +
    labs( title = titulo ) +
    labs(x="Remuneração em R$") + labs(y="Número de Servidores") + 
    theme(axis.text.x = element_text(angle = 70, hjust = 1))
}

salaryHistogramRemuneracaoPerVinculo <- function(data,classe){
  if ( missing(classe) ){
    titulo <- "Histograma dos Salários"
  } else {
    titulo <- paste("Histograma dos Salários dos",classe)
  }
  
  ggplot(data, aes(x=Remuneração)) +
    geom_histogram(aes(fill = ..count..), binwidth=500, colour="black", alpha = 0.5) +
    facet_wrap(~Vínculo, scales = "free" , ncol = 2) +
    labs( title = titulo ) +
    labs(x="Remuneração em R$") + labs(y="Número de Servidores") + 
    theme(axis.text.x = element_text(angle = 70, hjust = 1))
}

salaryHistogramTotalLiquido <- function(data,classe){
  if ( missing(classe) ){
    titulo <- "Histograma dos Salários"
  } else {
    titulo <- paste("Histograma dos Salários dos",classe)
  }
  
  ggplot(data, aes(x=Total.Líquido)) +
    geom_histogram(aes(fill = ..count..), binwidth=500, colour="black", alpha = 0.5) +
    labs( title = titulo ) +
    labs(x="Total Liquido em R$") + labs(y="Número de Servidores") + 
    theme(axis.text.x = element_text(angle = 70, hjust = 1))
}

salaryHistogramTotalLiquidoPerVinculo <- function(data,classe){
  if ( missing(classe) ){
    titulo <- "Histograma dos Salários"
  } else {
    titulo <- paste("Histograma dos Salários dos",classe)
  }
  
  ggplot(data, aes(x=Total.Líquido)) +
    geom_histogram(aes(fill = ..count..), binwidth=500, colour="black", alpha = 0.5) +
    facet_wrap(~Vínculo, scales = "free" , ncol = 2) +
    labs( title = titulo ) +
    labs(x="Total Liquido em R$") + labs(y="Número de Servidores") +
    theme(axis.text.x = element_text(angle = 70, hjust = 1))
}

boxplotVencimentoVinculo <- function(data,classe){
  if ( missing(classe) ){
    titulo <- "Vencimento Liquido"
  } else {
    titulo <- paste("Vencimento Liquido dos",classe)
  }
  ggplot(na.omit(data),aes(x = Vínculo,
                                 y=Total.Líquido,group=Vínculo,colour=Vínculo) ) + 
    geom_point(alpha = 0.2, position = "jitter" , show.legend = FALSE) +
    geom_boxplot(aes(group=Vínculo), alpha = 0.9) +
    labs( title = titulo ) +
    labs(x="") + labs(y="Valores em R$") +
    theme(axis.text.x = element_text(angle = 70, hjust = 1))
    
}
