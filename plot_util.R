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
    labs(x="Remuneração em R$") + labs(y="Número de Servidores")
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
    labs(x="Remuneração em R$") + labs(y="Número de Servidores")
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
    labs(x="Total Liquido em R$") + labs(y="Número de Servidores")
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
    labs(x="Total Liquido em R$") + labs(y="Número de Servidores")
}