library(gtable)
library(grid) 
library(reshape2)
library(plyr)
library(ggplot2)

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

#plot_QuantidadeServidoresGastoBrutoAnual(fullData)

plot_folhaVsCargo <- function(data){

  meltData_a <- melt(data[complete.cases(data$Total.Bruto),], id=c("ano", "Cargo") , measure.vars = c("Total.Bruto"))
  wd_a <- dcast(meltData_a, ano + Cargo ~ variable , sum)
  
  #wd_a$Cargo <- reorder(wd_a$Cargo,wd_a$Total.Bruto)
  wd_a <- wd_a[with(wd_a, order(Total.Bruto, Cargo)), ]
  
  ggplot(wd_a, aes(x=ano,y=Total.Bruto/1e6) ) +
    geom_bar(stat="identity",aes(fill = Cargo)) + 
    geom_text(aes(label=as.integer(Total.Bruto/1e6)), vjust=1.5, colour="white") +
    scale_x_continuous(breaks = seq(2009,2017) ) + 
    labs( title = "Gastos com a folha por cargo" ) +
    labs(x="") + labs(y="Gastos em Milhões de R$") + 
    theme(axis.text.x = element_text(angle = 70, hjust = 1)) +
    theme(legend.position = "bottom")
}

#plot_folhaVsCargo(fullData)

plot_folhaVsCargo_Quantitativo <- function(data){
  
  meltData_a <- melt(data[complete.cases(data$Total.Bruto),], id=c("ano", "Cargo") , measure.vars = c("Total.Bruto"))
  wd_a <- dcast(meltData_a, ano + Cargo ~ variable , sum)
  wd_a <- wd_a[with(wd_a, order(Total.Bruto, Cargo)), ]
  
  wdQS_a <- ddply(data[complete.cases(data$Total.Bruto),],~ano + Cargo,summarise,numero_de_servidores=length(unique(Matrícula)))
  
  
  p1 <- ggplot(wdQS_a, aes(x=ano,y=numero_de_servidores) ) +
    geom_line(aes(linetype = Cargo,color = Cargo), size=1.1) + 
    geom_point(aes(shape  = Cargo,color = Cargo), size=3) + 
    geom_text(aes(label=as.integer(numero_de_servidores)), vjust=1.5) +
    labs(x="") + labs(y="Quantidade de Servidores") + 
    scale_x_continuous(breaks = seq(2009,2017) ) + 
    theme(panel.background = element_blank()) +
    theme(panel.grid.minor = element_blank(), 
          panel.grid.major = element_blank(),
          panel.grid.major.x = element_blank(),
          axis.title.y=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank()) +
    theme(legend.position = "top")
  
  
  p2 <- ggplot(wd_a, aes(x=ano,y=Total.Bruto/1e6) ) +
      geom_bar(stat="identity",aes(color = Cargo ),fill = "transparent" ,alpha = 0.8,size=1) + 
      geom_text(aes(label=as.integer(Total.Bruto/1e6),colour= Cargo), vjust=1.5) +
      scale_x_continuous(breaks = seq(2009,2017) ) + 
      labs( title = "Gastos com a folha por cargo" ) +
      labs(x="") + labs(y="Gastos em Milhões de R$") + 
      theme(axis.text.x = element_text(angle = 70, hjust = 1)) +
      theme(legend.position = "bottom") +
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

#plot_folhaVsCargo_Quantitativo(fullData)

plot_folhaVsVinculo <- function(data){
  
  meltData_a <- melt(data[complete.cases(data$Total.Bruto),], id=c("ano", "Vínculo") , measure.vars = c("Total.Bruto"))
  wd_a <- dcast(meltData_a, ano + Vínculo ~ variable , sum)
  
  ggplot(wd_a, aes(x=ano,y=Total.Bruto/1e6) ) +
    geom_bar(stat="identity",aes(fill = Vínculo)) + 
    scale_x_continuous(breaks = seq(2009,2017) ) + 
    labs( title = "Gastos com a folha por Vínculo" ) +
    labs(x="") + labs(y="Gastos em Milhões de R$") + 
    theme(axis.text.x = element_text(angle = 70, hjust = 1)) +
    theme(legend.position = "bottom")
}

#plot_folhaVsVinculo(fullData)


lixo_percentPorCargo <- function(data){
  
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



plot_pecentualPorVinculo <- function(data,filter){
  
  
  meltData_a <- melt(data[complete.cases(data$Total.Bruto),], id=c("ano", "Vínculo") , measure.vars = c("Total.Bruto"))
  wd_a <- dcast(meltData_a, ano + Vínculo ~ variable , sum)
  wd_a <- wd_a[with(wd_a, order(Total.Bruto, Vínculo)), ]
  
  z <- dcast(meltData_a, ano ~ variable , sum )
  z <- rename(z, c("Total.Bruto"="total_ano"))
  z <- merge(wd_a, z, by=c("ano","ano"))
  z['percent'] <- z$Total.Bruto / z$total_ano
  
  if ( ! missing(filter) ){
    z <- z[z$Vínculo != 'NAO SEI',]
    z <- z[z$Vínculo != 'ESTATUTÁRIO',]
  } 
  
  
  ggplot(z, aes(x=ano,y=percent) ) +
    geom_line(aes(color = Vínculo), size=1) + 
    geom_point(aes(shape  = Vínculo,color = Vínculo), size=3) + 
    geom_text(aes(label=as.integer(percent*100)), vjust=1.5) +
    scale_x_continuous(breaks = seq(2009,2017) ) + 
    scale_y_continuous(labels = scales::percent) +
    labs( title = "Gastos da folha por Vínculo" ) +
    labs(x="") + labs(y="") + 
    theme(axis.text.x = element_text(angle = 70, hjust = 1)) +
    theme(legend.position = "bottom")
}

#plot_pecentualPorVinculo(fullData)
#plot_pecentualPorVinculo(fullData,True)

plot_pecentualPorCargoVinculo <- function(data,filter){
  meltData_a <- melt(data[complete.cases(data$Total.Bruto),], id=c("ano", "Vínculo" , "Cargo") , measure.vars = c("Total.Bruto"))
  wd_a <- dcast(meltData_a, ano + Cargo + Vínculo ~ variable , sum)
  
  z <- dcast(meltData_a, ano ~ variable , sum )
  z <- rename(z, c("Total.Bruto"="total_ano"))
  z <- merge(wd_a, z, by=c("ano","ano"))
  z['percent'] <- z$Total.Bruto / z$total_ano
  
  if ( ! missing(filter) ){
    z <- z[z$Vínculo != 'NAO SEI',]
    z <- z[z$Vínculo != 'ESTATUTÁRIO' & ( z$Cargo == 'TÉCNICO ADMINISTRATIVO' | z$Cargo == 'PROFESSOR'),]
  } 
  
  
  ggplot(z, aes(x=ano,y=Total.Bruto/1e6) ) +
    geom_line(aes(color = interaction(Cargo,Vínculo)), size=1) + 
    geom_point(aes(shape  = interaction(Cargo,Vínculo),color = interaction(Cargo,Vínculo)), size=3) + 
    #geom_text(aes(label=as.integer(Total.Bruto/1e6)), vjust=1.5) +
    scale_x_continuous(breaks = seq(2009,2017) ) + 
    scale_y_continuous(breaks=scales::pretty_breaks(n = 20)) +
    labs( title = "Gastos da folha por Cargo e Vínculo" ) +
    labs(x="") + labs(y="Gastos em milhões de R$") + labs(color = " ",shape = " ")+
    theme(axis.text.x = element_text(angle = 70, hjust = 1)) +
    theme(legend.position = "bottom")
}

#plot_pecentualPorCargoVinculo(fullData)
#plot_pecentualPorCargoVinculo(fullData,TRUE)

plot_custoCargoVinculoEstatutario_Quantitativo <- function(data){
  
  meltData_a <- melt(data[complete.cases(data$Total.Bruto),], id=c("ano", "Vínculo" , "Cargo") , measure.vars = c("Total.Bruto"))
  wd_a <- dcast(meltData_a, ano + Cargo + Vínculo ~ variable , sum)
  
  
  z <- dcast(meltData_a, ano ~ variable , sum )
  z <- rename(z, c("Total.Bruto"="total_ano"))
  z <- merge(wd_a, z, by=c("ano","ano"))
  z['percent'] <- z$Total.Bruto / z$total_ano
  
  z <- z[z$Vínculo == 'ESTATUTÁRIO',]
  z <- z[with(z, order(Total.Bruto, Vínculo)), ]
  
  
  wdQS_a <- ddply(data[complete.cases(data$Total.Bruto),],~ano + Cargo + Vínculo ,summarise,numero_de_servidores=length(unique(Matrícula)))
  wdQS_a <- wdQS_a[wdQS_a$Vínculo == 'ESTATUTÁRIO',]
  
  
  p1 <- ggplot(wdQS_a, aes(x=ano,y=numero_de_servidores) ) +
    geom_line(aes(linetype = interaction(Cargo,Vínculo),color = interaction(Cargo,Vínculo)), size=1.1) + 
    geom_point(aes(shape  = interaction(Cargo,Vínculo),color = interaction(Cargo,Vínculo)), size=3) + 
    geom_text(aes(label=as.integer(numero_de_servidores)), vjust=1.5) +
    labs(x="") + labs(y="Quantidade de Servidores") + 
    scale_x_continuous(breaks = seq(2009,2017) ) + 
    theme(panel.background = element_blank()) +
    theme(panel.grid.minor = element_blank(), 
          panel.grid.major = element_blank(),
          panel.grid.major.x = element_blank(),
          axis.title.y=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank()) +
    theme(legend.position = "top")
  
  
  p2 <- ggplot(z, aes(x=ano,y=Total.Bruto/1e6) ) +
    geom_bar(stat="identity",aes(color = interaction(Cargo,Vínculo) ),fill = "transparent" ,alpha = 0.8,size=1) + 
    geom_text(aes(label=as.integer(Total.Bruto/1e6),colour=interaction(Cargo,Vínculo)), vjust=1.5) +
    scale_x_continuous(breaks = seq(2009,2017) ) + 
    labs( title = "Gastos com a folha com servidores estatutários" ) +
    labs(x="") + labs(y="Gastos em Milhões de R$") + 
    labs(color = " ",shape = " ") +
    scale_y_continuous(breaks=scales::pretty_breaks(n = 20)) +
    theme(axis.text.x = element_text(angle = 70, hjust = 1)) +
    theme(legend.position = "bottom") +
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

#plot_custoCargoVinculoEstatutario_Quantitativo(fullData)

plot_gratificacoesBar <- function(data,filter){
  
  d <- data[ data$Gratificação.Cargo.Comissionado.Função != 0,]
  d['vg'] <- d$Gratificação.Cargo.Comissionado.Função
  
  meltData_a <- melt(d, id=c("ano") , measure.vars = "vg")
  wd_a <- dcast(meltData_a, ano ~ variable , sum)
  
  #wd_a <- wd_a[with(wd_a, order(vg, -Cargo )), ]
  
  z <- dcast(meltData_a, ano ~ variable , sum )
  z <- rename(z, c("vg"="total_ano"))
  z <- merge(wd_a, z, by=c("ano","ano"))
  z['percent'] <- z$Gratificação.Cargo.Comissionado.Função / z$total_ano
  
  if ( ! missing(filter) ){
    z <- z[z$Vínculo != 'NAO SEI',]
    z <- z[z$Vínculo != 'ESTATUTÁRIO' & ( z$Cargo == 'TÉCNICO ADMINISTRATIVO' | z$Cargo == 'PROFESSOR'),]
  } 
  
  ggplot(z, aes(x=ano,y=vg/1e6) ) +
    geom_bar(stat="identity") + 
    #geom_bar(stat="identity",position="dodge", aes(fill = 'Total' )) +
    scale_x_continuous(breaks = seq(2009,2017) ) + 
    scale_y_continuous(breaks=scales::pretty_breaks(n = 20)) +
    labs( title = "Gastos da folha por Cargo e Vínculo" ) +
    labs(x="") + labs(y="Gastos em milhões de R$") + labs(color = " ",shape = " ")+
    theme(axis.text.x = element_text(angle = 70, hjust = 1)) +
    theme(legend.position = "bottom")
}

#plot_gratificacoesBar(fullData)


plot_gratificacoesBarCargo <- function(data,filter){
  
  d <- data[ data$Gratificação.Cargo.Comissionado.Função != 0,]
  d['vg'] <- d$Gratificação.Cargo.Comissionado.Função
  
  meltData_a <- melt(d, id=c("ano" , "Cargo") , measure.vars = "vg")
  wd_a <- dcast(meltData_a, ano + Cargo ~ variable , sum)
  
  #wd_a <- wd_a[with(wd_a, order(vg, -Cargo )), ]
  
  z <- dcast(meltData_a, ano ~ variable , sum )
  z <- rename(z, c("vg"="total_ano"))
  z <- merge(wd_a, z, by=c("ano","ano"))
  z['percent'] <- z$Gratificação.Cargo.Comissionado.Função / z$total_ano
  
  if ( ! missing(filter) ){
    z <- z[z$Vínculo != 'NAO SEI',]
    z <- z[z$Vínculo != 'ESTATUTÁRIO' & ( z$Cargo == 'TÉCNICO ADMINISTRATIVO' | z$Cargo == 'PROFESSOR'),]
  } 
  
  ggplot(z, aes(x=ano,y=vg/1e6) ) +
    geom_bar(stat="identity",position="dodge", aes(fill = Cargo )) + 
    #geom_bar(stat="identity",position="dodge", aes(fill = 'Total' )) +
    scale_x_continuous(breaks = seq(2009,2017) ) + 
    scale_y_continuous(breaks=scales::pretty_breaks(n = 20)) +
    labs( title = "Gastos da folha por Cargo e Vínculo" ) +
    labs(x="") + labs(y="Gastos em milhões de R$") + labs(color = " ",shape = " ")+
    theme(axis.text.x = element_text(angle = 70, hjust = 1)) +
    theme(legend.position = "bottom")
}

#plot_gratificacoesBarCargo(fullData)


plot_gratificacoesCargoVinculo <- function(data,filter){
  
  d <- data[ data$Gratificação.Cargo.Comissionado.Função != 0,]
  d['vg'] <- d$Gratificação.Cargo.Comissionado.Função
  
  meltData_a <- melt(d, id=c("ano", "Vínculo" , "Cargo") , measure.vars = "vg")
  wd_a <- dcast(meltData_a, ano + Cargo + Vínculo ~ variable , sum)
  
  
  z <- dcast(meltData_a, ano ~ variable , sum )
  z <- rename(z, c("vg"="total_ano"))
  z <- merge(wd_a, z, by=c("ano","ano"))
  z['percent'] <- z$Gratificação.Cargo.Comissionado.Função / z$total_ano
  
  if ( ! missing(filter) ){
    z <- z[z$Vínculo != 'NAO SEI',]
    z <- z[z$Vínculo != 'ESTATUTÁRIO' & ( z$Cargo == 'TÉCNICO ADMINISTRATIVO' | z$Cargo == 'PROFESSOR'),]
  } 
  
  ggplot(z, aes(x=ano,y=vg/1e6) ) +
    geom_line(aes(color = interaction(Cargo,Vínculo)), size=1) + 
    geom_point(aes(shape  = interaction(Cargo,Vínculo),color = interaction(Cargo,Vínculo)), size=3) + 
    #geom_text(aes(label=as.integer(Total.Bruto/1e6)), vjust=1.5) +
    scale_x_continuous(breaks = seq(2009,2017) ) + 
    scale_y_continuous(breaks=scales::pretty_breaks(n = 20)) +
    labs( title = "Gastos da folha por Cargo e Vínculo" ) +
    labs(x="") + labs(y="Gastos em milhões de R$") + labs(color = " ",shape = " ")+
    theme(axis.text.x = element_text(angle = 70, hjust = 1)) +
    theme(legend.position = "bottom")
}

#plot_gratificacoesCargoVinculo(fullData)

#funcao para agrupar os cargos
agrupar_fxComissionada <- function(val) {
  tks <- strsplit(val, " ")
  return(tks[[1]][1])
  
}

plot_gratificacoesTipo <- function(data,filter){
  
  d <- data[ data$Gratificação.Cargo.Comissionado.Função != 0,]
  d['vg'] <- d$Gratificação.Cargo.Comissionado.Função
  
  meltData_a <- melt(d, id=c("ano", "Cargo" , "Cargo.Comissionado") , measure.vars = "vg")
  wd_a <- dcast(meltData_a, ano + Cargo + Cargo.Comissionado ~ variable , sum)
  
  
  z <- dcast(meltData_a, ano ~ variable , sum )
  z <- rename(z, c("vg"="total_ano"))
  z <- merge(wd_a, z, by=c("ano","ano"))
  z['percent'] <- z$Gratificação.Cargo.Comissionado.Função / z$total_ano
  
  if ( ! missing(filter) ){
    z <- z[z$Vínculo != 'NAO SEI',]
    z <- z[z$Vínculo != 'ESTATUTÁRIO' & ( z$Cargo == 'TÉCNICO ADMINISTRATIVO' | z$Cargo == 'PROFESSOR'),]
  } 
  
  z['grupo_fc'] <-as.character(lapply(as.character(z$Cargo.Comissionado),agrupar_fxComissionada))
  
  z$grupo_fc <- reorder(z$grupo_fc, z$vg)
  z$grupo_fc <- factor(z$grupo_fc, levels=rev(rev(levels(z$grupo_fc))) )
  
  ggplot(z, aes(x=ano,y=vg/1e6) ) +
    geom_bar(stat="identity", aes(fill = grupo_fc )) + 
    #geom_text(aes(label=as.integer(Total.Bruto/1e6)), vjust=1.5) +
    scale_x_continuous(breaks = seq(2009,2017) ) + 
    scale_y_continuous(breaks=scales::pretty_breaks(n = 10)) +
    labs( title = "Gastos com funções gratificados por Cargo Comissionado" ) +
    labs(x="") + labs(y="Gastos em milhões de R$") + labs(color = " ",fill = " ")+
    theme(axis.text.x = element_text(angle = 70, hjust = 1)) +
    theme(legend.position = "bottom") + 
    guides(fill = guide_legend(ncol = 3))
}

#plot_gratificacoesTipo(fullData[fullData$Cargo == 'PROFESSOR',])
#plot_gratificacoesTipo(fullData[fullData$Cargo != 'PROFESSOR',])

plot_gratificacoesTipoDetalhe <- function(data,filter){
  
  d <- data[ data$Gratificação.Cargo.Comissionado.Função != 0,]
  d['vg'] <- d$Gratificação.Cargo.Comissionado.Função
  
  meltData_a <- melt(d, id=c("ano", "Cargo" , "Cargo.Comissionado") , measure.vars = "vg")
  wd_a <- dcast(meltData_a, ano + Cargo + Cargo.Comissionado ~ variable , sum)
  
  #wd_a <- wd_a[with(wd_a, order(vg, Cargo.Comissionado)), ]
  
  z <- dcast(meltData_a, ano ~ variable , sum )
  z <- rename(z, c("vg"="total_ano"))
  z <- merge(wd_a, z, by=c("ano","ano"))
  z['percent'] <- z$Gratificação.Cargo.Comissionado.Função / z$total_ano
  
  z$Cargo.Comissionado <- reorder(z$Cargo.Comissionado, z$vg)
  z$Cargo.Comissionado <- factor(z$Cargo.Comissionado, levels=rev(rev(levels(z$Cargo.Comissionado))) )
  
  if ( ! missing(filter) ){
      titulo <- paste("Gastos com funções gratificados para",filter)
  } else {
    titulo <- "Gastos com funções gratificados"
  }
  
  ggplot(z, aes(x=ano,y=vg/1e3) ) +
    geom_bar(stat="identity", aes(fill = Cargo.Comissionado )) +
    scale_x_continuous(breaks = seq(2009,2017) ) + 
    scale_y_continuous(breaks=scales::pretty_breaks(n = 10)) +
    labs( title = titulo ) +
    labs(x="") + labs(y="Gastos em milhares (1e3) de R$") + labs(color = " ",shape = " " , fill="")+
    theme(axis.text.x = element_text(angle = 70, hjust = 1)) +
    theme(legend.position = "bottom") + 
    guides(fill = guide_legend(ncol = 3))
}

#fullData['grupo_fc'] <-as.character(lapply(as.character(fullData$Cargo.Comissionado),agrupar_fxComissionada))
#temp <- fullData[complete.cases(fullData$grupo_fc),]

#for (gfc in unique(temp[temp$Cargo == 'PROFESSOR',]$grupo_fc)){
#  print(plot_gratificacoesTipoDetalhe(temp[(temp$Cargo == 'PROFESSOR') & (temp$grupo_fc == gfc),]))
#}

#for (gfc in unique(temp[temp$Cargo != 'PROFESSOR',]$grupo_fc)){
#  print(plot_gratificacoesTipoDetalhe(temp[(temp$Cargo != 'PROFESSOR') & (temp$grupo_fc == gfc),]))
#}