# TMB
A pipeline to calculate tumour mutation burden based on criteria suggested by the TMB Harmonization Consortium


The filtering criteria and the thresholds in this pipeline is selected based on the parameters suggested by Merino et al. (1)


## Required Files

To run this pipeline, TCGA mutation file (2), a reference genome file (3) and a CCDS file (release 15)(4) containing information about exonic regions, are required. In addition to these files, a perl script is needed to convert the TCGA MAF file to VCF format that is included in the code. This script is a part of vcf2maf package written by Cyriac Kandoth et al. (5). The files mentioned above can be downloaded using these commands:

Mutation file:
`curl --remote-name --remote-header-name 'https://api.gdc.cancer.gov/data/1c8cfe5f-e52d-41ba-94da-f15ea1337efc' -o mc3.v0.2.8.PUBLIC.maf.gz`

CCDS file (exonic regions):
`curl 'https://ftp.ncbi.nlm.nih.gov/pub/CCDS/archive/15/CCDS.20131129.txt' -o CCDS.20131129.txt`

References:
1. Merino DM, McShane LM, Fabrizio D, Funari V, Chen S, White JR, et al. Establishing guidelines to harmonize tumor mutational burden (TMB): in silico assessment of variation in TMB quantification across diagnostic platforms: phase I of the Friends of Cancer Research TMB Harmonization Project. J Immunother Cancer. 2020 Mar 26;8(1): e000147.
