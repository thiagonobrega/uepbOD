library(gtable)
library(grid) # low-level grid functions are required
library(reshape2)
library(plyr)

plot_QuantidadeServidoresGastoBrutoAnual <- function(data){
  #
  meltData_a <- melt(data[complete.cases(data$Total.Bruto),], id=c("ano") , measure.vars = c("Total.Bruto"))
  wd_a <- dcast(meltData_a, ano ~ variable , sum)
  #servidore/ano
  wdQS_a <- ddply(data,~ano,summarise,numero_de_servidores=length(unique(Matrícula)))
  
  
  p1 <- ggplot(wdQS_a, aes(x=ano,y=numero_de_servidores) ) +
    geom_line(colour="red", size=1.1) + 
    geom_point(colour="red", size=3) + 
    geom_text(aes(label=as.integer(numero_de_servidores)), vjust=1.5, colour="red") +
    labs(x="") + labs(y="Quantidade de Servidores") + 
    scale_x_continuous(breaks = seq(2009,2017) ) + 
    theme(panel.background = element_blank()) +
    theme(panel.grid.minor = element_blank(), 
          panel.grid.major = element_blank(),
          panel.grid.major.x = element_blank(),
          axis.title.y=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank())
  
  p2 <- ggplot(wd_a, aes(x=ano,y=Total.Bruto/1e6) ) +
    geom_bar(stat="identity") + 
    scale_x_continuous(breaks = seq(2009,2017) ) + 
    labs( title = "Gastos com a folha vs Quantitativo de servidores" ) +
    labs(x="") + labs(y="Gastos em Milhões de R$") + 
    theme(axis.text.x = element_text(angle = 70, hjust = 1)) +
    theme(panel.background = element_blank()) + 
    theme(panel.grid.minor = element_blank(), 
          panel.grid.major = element_line(color = "gray50", size = 0.25),
          panel.grid.major.x = element_blank())
  
  
  
  # extract gtable
  g1 <- ggplot_gtable(ggplot_build(p2))
  g2 <- ggplot_gtable(ggplot_build(p1))
  
  # overlap the panel of 2nd plot on that of 1st plot
  pp <- c(subset(g1$layout, name == "panel", se = t:r))
  g <- gtable_add_grob(g1, g2$grobs[[which(g2$layout$name == "panel")]], pp$t, 
                       pp$l, pp$b, pp$l)
  
  # draw it
  grid.draw(g)
}

plot_QuantidadeServidoresGastoBrutoAnual(fullData)

xpt1 <- function(data){

  meltData_a <- melt(data[complete.cases(data$Total.Bruto),], id=c("ano", "Cargo") , measure.vars = c("Total.Bruto"))
  wd_a <- dcast(meltData_a, ano + Cargo ~ variable , sum)
  
  
  ggplot(wd_a, aes(x=ano,y=Total.Bruto/1e6) ) +
    geom_bar(stat="identity",aes(fill = Cargo)) + 
    geom_text(aes(label=as.integer(Total.Bruto/1e6)), vjust=1.5, colour="white") +
    scale_x_continuous(breaks = seq(2009,2017) ) + 
    labs( title = "Gastos com a folha por cargo" ) +
    labs(x="") + labs(y="Gastos em Milhões de R$") + 
    theme(axis.text.x = element_text(angle = 70, hjust = 1)) +
    theme(legend.position = "bottom")
}

xpt1(fullData)

xpt2 <- function(data){
  
  meltData_a <- melt(data[complete.cases(data$Total.Bruto),], id=c("ano", "Cargo") , measure.vars = c("Total.Bruto"))
  wd_a <- dcast(meltData_a, ano + Cargo ~ variable , sum)
  
  z <- dcast(meltData_a, ano ~ variable , sum )
  z <- rename(z, c("Total.Bruto"="total_ano"))
  z <- merge(wd_a, z, by=c("ano","ano"))
  z['percent'] <- z$Total.Bruto / z$total_ano
  
  
  ggplot(z, aes(x=ano,y=percent) ) +
    geom_bar(stat="identity", aes(fill = Cargo)) + 
    geom_text(aes(label=as.integer(percent*100)), vjust=1.5, colour="white") +
    scale_x_continuous(breaks = seq(2009,2017) ) + 
    labs( title = "Gastos com a folha vs Quantitativo de servidores" ) +
    labs(x="") + labs(y="Gastos em Milhões de R$") + 
    scale_y_continuous(labels = scales::percent) +
    theme(axis.text.x = element_text(angle = 70, hjust = 1)) +
    theme(legend.position = "bottom")
}

xpt2(fullData)

xpto1 <- function(data){
  
  meltData_a <- melt(data[complete.cases(data$Total.Bruto),], id=c("ano", "Vínculo") , measure.vars = c("Total.Bruto"))
  wd_a <- dcast(meltData_a, ano + Vínculo ~ variable , sum)
  
  z <- dcast(meltData_a, ano ~ variable , sum )
  z <- rename(z, c("Total.Bruto"="total_ano"))
  z <- merge(wd_a, z, by=c("ano","ano"))
  z['percent'] <- z$Total.Bruto / z$total_ano
  
  
  ggplot(z, aes(x=ano,y=Total.Bruto/1e6) ) +
    geom_bar(stat="identity",aes(fill = Vínculo)) + 
    scale_x_continuous(breaks = seq(2009,2017) ) + 
    labs( title = "Gastos com a folha por vinculo" ) +
    labs(x="") + labs(y="Gastos em Milhões de R$") + 
    theme(axis.text.x = element_text(angle = 70, hjust = 1)) +
    theme(legend.position = "bottom")
}

xpto1(fullData)