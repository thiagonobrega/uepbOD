files <- list.files(path = 'data/', pattern = '.csv')

template <- 'reports/VisaoGeral.Rmd'

for (name in files) {
  title <- "Visão Geral do mês "
  input <- paste("../data/",name,sep="")
  output <- paste("../out/VisaoGeral",gsub('csv','html',name),sep="")
  title <- paste(title,gsub('.csv','',name),sep="")
  print(title)
  rmarkdown::render(template, params = list(input_file = input,set_title = title,set_date = "10 de Maio 2017"), output_file = output)
}