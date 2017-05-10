files <- list.files(path = 'data/', pattern = '.csv')[1:4]

template <- 'reports/report_01.Rmd'
for (name in files) {
  input <- paste("../data/",name,sep="")
  output <- paste("../out/",gsub('csv','html',name),sep="")
  print(input)
  print(output)
  rmarkdown::render(template, params = list(input_file = input), output_file = output)
}