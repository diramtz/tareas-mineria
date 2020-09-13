library(rvest)
library(dplyr)


url <- "https://www.timeanddate.com/weather/mexico/mexico-city/hourly"
info <- url %>% read_html() %>%
  html_nodes("td:nth-child(9) , .small , .wt-ic+ td , #wt-hbh tbody th")  %>% 
  html_text()

tabla <- matrix(info,ncol=4, byrow = TRUE)
df <- as.data.frame(tabla)
names(df) <- c("Time","Temp","Weather", "Chance")
View(head(df))

#write.csv(df, "/home/diramtz/Documents/Minería/TareaWS.csv")
