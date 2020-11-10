path = '../processed_data/'

find_TMB <- function(maf_file) {
  maf <- read.table(paste(path, maf_file, sep=""))
}
