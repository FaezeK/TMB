if(!require("sqldf", character.only = TRUE)){
  install.packages("sqldf", dependencies = TRUE)
}

library(sqldf)

args = commandArgs(trailingOnly=TRUE)

find_TMB <- function(maf_file, exon_mut_coord) {
  # read input files
  maf <- read.delim(maf_file, header = TRUE, sep = "\t", comment.char = "#", stringsAsFactors = FALSE)
  coord <- read.delim(exon_mut_coord, header = FALSE, sep = "\t", comment.char = "#", stringsAsFactors = FALSE)

  # fix column names
  colnames(coord) <- c("chr","strt","ends")
  colnames(maf)[8] <- "first_strand"

  # find the mutations that occur in exonic regions
  maf_intersect_coord <- sqldf("select m.* from maf as m
                                        join coord as c
                                        on m.Chromosome = c.chr
                                        and m.Start_Position = c.strt
                                        and m.End_Position = c.ends")

  # filter for mutations with vaf >= 0.05
  maf_intersect_coord$vaf <- maf_intersect_coord$t_alt_count / maf_intersect_coord$t_depth
  maf_intersect_coord <- maf_intersect_coord[maf_intersect_coord$vaf >= 0.05,]

  # filter for mutations with tumor depth >= 25
  maf_intersect_coord <- maf_intersect_coord[maf_intersect_coord$t_depth >= 25,]

  # harmonize variant types (the below lines were adopted from J. Topham code)
  maf_intersect_coord$Consequence2 <- maf_intersect_coord$Consequence
  maf_intersect_coord$Consequence2[grep("missense", maf_intersect_coord$Consequence2)] <- "missense"
  maf_intersect_coord$Consequence2[grep("frameshift", maf_intersect_coord$Consequence2)] <- "frameshift_INDEL"
  maf_intersect_coord$Consequence2[grep("inframe", maf_intersect_coord$Consequence2)] <- "inframe_INDEL"
  maf_intersect_coord$Consequence2[grep("splice", maf_intersect_coord$Consequence2)] <- "splice"
  maf_intersect_coord$Consequence2[grep("stop_gain", maf_intersect_coord$Consequence2)] <- "nonsense"
  maf_intersect_coord$Consequence2[grep("stop_lost", maf_intersect_coord$Consequence2)] <- "nonstop"
  maf_intersect_coord$Consequence2[grep("UTR|coding_seq|codon_var|miRNA|exon_var|transcript_var|
                                      protein_alter|start_lost|stop_retain|transcript_ablat", maf_intersect_coord$Consequence2)] <- "other"
  maf_intersect_coord$Consequence2[grep("downstream|upstream|intron|synonym", maf_intersect_coord$Consequence2)] <- "other_silent"

  # filter for mutations with specific mutation types
  maf_intersect_coord <- maf_intersect_coord[maf_intersect_coord$Consequence2 %in% c("frameshift_INDEL","inframe_INDEL","missense","nonsense"),]

  # filter for mutations with alternative variant count >= 3
  maf_intersect_coord <- maf_intersect_coord[maf_intersect_coord$t_alt_count >= 3,]

  # find TMB per sample
  maf_snv_per_sample <- sqldf("select Tumor_Sample_Barcode, count(*) cnt from maf_intersect_coord group by Tumor_Sample_Barcode")
  maf_snv_per_sample$tmb <- maf_snv_per_sample$cnt / 33

  write.table(maf_snv_per_sample, file="results/tmb.tsv", quote=FALSE, sep="\t", row.names=FALSE, col.names=TRUE)
}

find_TMB(args[1], args[2])
