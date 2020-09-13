#ticdata <- read.table(file = "aux_ticdata1.txt", header = TRUE)
ticdata <- file.choose()
ticfix <- read.table(file = "ticdata1fix.txt", header = TRUE)
tictab <- read.delim(file = "ticdatapls.txt", header = TRUE)
