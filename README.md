# TMB
A pipeline to calculate tumour mutation burden based on criteria suggested by the TMB Harmonization Consortium


The filtering criteria and the thresholds in this pipeline is selected based on the parameters suggested by Merino et al. (1)


## Required Files

To run this pipeline, TCGA mutation file (2) and a CCDS file (release 15)(3) containing information about exonic regions, are required. These files can be downloaded using the following commands:

Mutation file:
> `curl --remote-name --remote-header-name 'https://api.gdc.cancer.gov/data/1c8cfe5f-e52d-41ba-94da-f15ea1337efc' -o mc3.v0.2.8.PUBLIC.maf.gz`

CCDS file (exonic regions):
> `curl 'https://ftp.ncbi.nlm.nih.gov/pub/CCDS/archive/15/CCDS.20131129.txt' -o CCDS.20131129.txt`

After files are downloaded the gzipped files should be unzipped:
  
> `gunzip mc3.v0.2.8.PUBLIC.maf.gz`
  
In addition to these files, the file with TSS (tissue source sites) was downloaded from https://gdc.cancer.gov/resources-tcga-users/tcga-code-tables that is already included here.
  
## Running the pipeline

After cloning the Git repo, the 2 files mentioned above should be moved into "data" directory.
  
To run the pipeline on one CPU core, please go to TMB directory and run this code:
> `snakemake -j1`
  
If you would like to use all available cores, you can run the pipeline in TMB with:
> `snakemake -j`
  
### References:
1. Merino DM, McShane LM, Fabrizio D, Funari V, Chen S, White JR, et al. Establishing guidelines to harmonize tumor mutational burden (TMB): in silico assessment of variation in TMB quantification across diagnostic platforms: phase I of the Friends of Cancer Research TMB Harmonization Project. J Immunother Cancer. 2020 Mar 26;8(1): e000147.
2. Ellrott K, Bailey MH, Saksena G, Covington KR, Kandoth C, Stewart C, et al. Scalable Open Science Approach for Mutation Calling of Tumor Exomes Using Multiple Genomic Pipelines. Cell Syst. 2018 Mar 28;6(3):271-281.
3. The Concensus CDS of NCBI [internet]. CCDS Database; 2013 Nov [cited 2020 Nov 9]. Available from: https://ftp.ncbi.nlm.nih.gov/pub/CCDS/archive/15/CCDS.20131129.txt



