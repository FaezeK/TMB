# TMB
A pipeline to calculate tumour mutation burden based on criteria suggested by the TMB Harmonization Consortium


The filtering criteria and the thresholds in this pipeline is selected based on the parameters suggested by Merino et al. (1)


## Required Files

To run this pipeline, TCGA mutation file (2), a reference genome file (3) and a CCDS file (release 15)(4) containing information about exonic regions, are required. In addition to these files, a perl script is needed to convert the TCGA MAF file to VCF format that is included in the code. This script is a part of vcf2maf package written by Cyriac Kandoth et al. (5). The files mentioned above can be downloaded using these commands:

Mutation file:
> `curl --remote-name --remote-header-name 'https://api.gdc.cancer.gov/data/1c8cfe5f-e52d-41ba-94da-f15ea1337efc' -o mc3.v0.2.8.PUBLIC.maf.gz`

Reference genome file:
> `curl 'ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz' -o Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz`

CCDS file (exonic regions):
> `curl 'https://ftp.ncbi.nlm.nih.gov/pub/CCDS/archive/15/CCDS.20131129.txt' -o CCDS.20131129.txt`

After files are downloaded the gzipped files should be unzipped:

> `gunzip Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz`
  
> `gunzip mc3.v0.2.8.PUBLIC.maf.gz`
  
## Running the pipeline

After cloning the Git repo, a directory called "data" should be made inside "TMB" directory and the 3 files mentioned above should be moved into "data" directory.
  
To run the pipeline on one CPU core, please go to TMB directory and run this code:
> `snakemake -j1`
  
If you would like to use all available cores, you can run the pipeline in TMB with:
> `snakemake -j`
  
### References:
1. Merino DM, McShane LM, Fabrizio D, Funari V, Chen S, White JR, et al. Establishing guidelines to harmonize tumor mutational burden (TMB): in silico assessment of variation in TMB quantification across diagnostic platforms: phase I of the Friends of Cancer Research TMB Harmonization Project. J Immunother Cancer. 2020 Mar 26;8(1): e000147.
2. Ellrott K, Bailey MH, Saksena G, Covington KR, Kandoth C, Stewart C, et al. Scalable Open Science Approach for Mutation Calling of Tumor Exomes Using Multiple Genomic Pipelines. Cell Syst. 2018 Mar 28;6(3):271-281.
3. Ensembl [internet]. Ensemble Database; 2014 March [cited 2020 Nov 9]. Available from: ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz
4. The Concensus CDS of NCBI [internet]. CCDS Database; 2013 Nov [cited 2020 Nov 9]. Available from: https://ftp.ncbi.nlm.nih.gov/pub/CCDS/archive/15/CCDS.20131129.txt
5. MSKCC vcf2maf [internet]. GitHub; 2020 Aug [cited 2020 Nov 5]. Available from: https://github.com/mskcc/vcf2maf


