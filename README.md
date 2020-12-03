# TMB Pipeline
A pipeline to calculate tumour mutational burden based on the criteria suggested by the TMB Harmonization Consortium in the paper by Merino et al. (1)

## Background

Immune check point inhibitors (ICIs) have been shown to improve the survival of patients with cancer and provide long term durable response in different types of cancer (1, 2). However, patients respond differently to immune checkpoint therapy and it is important to predict which patients can benefit from ICIs (1). Tumor mutational burden (TMB), which is defined as the number of somatic mutations per megabase of genome, has been shown to be a good predictive biomarker of response to ICI therapy (1). TMB can be found either through Whole Exome Sequencing (WES) or next generation sequencing targeted panels. There are usually discrepancies in the results obtained by these methods and although WES results are more accurate, targeted panels can provide the results in a time and cost-effective manner (1). In addition, variations can exist in the results due to inclusion of different mutation types, use of different bioinformatics pipelines, or because of other factors (1). Thus, the Friends TMB harmonization project proposed best practices to measure and report TMB with the goal to obtain accurate and consistent values (1). It is also important to note that there is some variability in the range of TMB values (range = maxTMB - minTMB) among different cancer types and different methodologies show higher discrepancies with larger ranges, while patients with higher TMB show better response to ICIs (1). Hence, it is very crucial to harmonize TMB definition and find the right thresholds of therapy response in different types of cancer (1).
  
## Rationale

As mentioned above, there is variability in TMB values that can affect clinical decision-making. Thus, the aim of this pipeline is to calculate TMB based on the suggestion from Merino et al. (1) for all TCGA samples (3). The results from this analysis is expected to assist in clinical decision making.
  
### Hypothesis

TMB is variable across and within cancer cohorts.
  
### Aims

1.	To calculate TMB per samples for all TCGA samples
2.	To compare the differences in TMB values across cancer types
3.	To provide a reference for targeted panels results
4.	Also, the code here can be used to find TMB in other cohorts providing the same cancer categories
  
### Package Dependencies

* Python3 version of Miniconda (3.8.3)
* Snakemake
* R = 4.0.2
* perl = 5.26.2
* bedtools = 2.27.1
* Python Modules: matplotlib = 3.3.2, pandas = 1.1.3, seaborn = 0.11.0
  
![DAG](/images/dag.png)
  
## Usage
  
### Required Files

To run this pipeline, TCGA mutation file (3) and a CCDS file (release 15)(4) containing information about exonic regions, are required. These files can be downloaded using the following commands:

Mutation file:
> `curl --remote-name --remote-header-name 'https://api.gdc.cancer.gov/data/1c8cfe5f-e52d-41ba-94da-f15ea1337efc' -o mc3.v0.2.8.PUBLIC.maf.gz`

CCDS file (exonic regions):
> `curl 'https://ftp.ncbi.nlm.nih.gov/pub/CCDS/archive/15/CCDS.20131129.txt' -o CCDS.20131129.txt`

After files are downloaded the gzipped files should be unzipped:
  
> `gunzip mc3.v0.2.8.PUBLIC.maf.gz`
  
In addition to these files, the file with TSS (tissue source sites) was downloaded from NCI Cancer Research Data Commons website that is already included here (5).
  
### Running the pipeline

After cloning the Git repo, the 2 files mentioned above should be moved into "data" directory.
  
To run the pipeline on one CPU core, please go to TMB directory and run this code: (please note that the Snakefile is stored in workflow directory, but the pipeline can be run from TMB directory as snakemake can locate the file)
> `snakemake -j1`
  
If you would like to use all available cores, you can run the pipeline in TMB with:
> `snakemake -j`
  
*To install snakemake:*
  
If snakemake is not installed, this page can be used as a guideline: https://snakemake.readthedocs.io/en/stable/getting_started/installation.html
  
In summary, first python3 version of Miniconda should be installed. Then, snakemake can be installed using following commands:
> `conda install -c conda-forge mamba`
  
> `mamba create -c conda-forge -c bioconda -n snakemake python=3.8.3 snakemake`

Then, the snakemake environment can be activated via:
> `conda activate snakemake`
  
and finally the commands to run the pipeline can be run.
  
*Note:*
In case the yaml file doesn't work as it is expected, the Python modules can be installed inside the snakemake environment using the following commands:
> `pip3 install matplotlib==3.3.2`
  
> `pip3 install seaborn==0.11.0`
  
## Input

The input to this pipeline is the set of somatic mutations found in TCGA samples (mc3.v0.2.8.PUBLIC.maf) (3). Every row in this file contains a mutation and it has 114 columns with information about each mutation including the location of the mutation, the name of the gene containing the mutation, and many other pieces of useful information. To learn more about MAF files, this website from NCI Cancer Research can be useful: https://docs.gdc.cancer.gov/Data/File_Formats/MAF_Format/ 
  
The TCGA maf file contains 3600963 mutations from 10295 patients with different types of cancer.
  
In addition, a file containing exonic regions of the human genome (hg19 construct) is needed to find the mutations that occur at exons (CCDS.20131129.txt) (4). Every row in this file contains a CCDS or Consensus Coding Sequence and it has 11 columns. The columns in order are genome id, chromosome, gene, gene id, ccds id, ccds status (to what extent the ccds is reviewed), DNA strand, from (the first DNA base that ccds starts from), to (end of ccds or last DNA base), location (the range of ccds), and match type (match status to SWISS PROT DB). Finally, a file with TCGA categories (5) is included in the package to be able to categorize samples and compare TMB values across different cancer types. Every row in this file contains each TCGA cancer category and it has four columns. The columns of this file are tissue source code, source site (where the data came from), study name, and Biospeciman Core Resource.
  
The TCGA samples are the test group in this analysis. There is no specific control group in this pipeline since the mutations present in mc3 file were extensively verified and the best tumor and normal samples were paired in all cases (3).
  
## Output

The output of this pipeline can be found in the results folder after it finishes running. The output comprises five files. The first one is a tsv file containing TMB values for all TCGA samples and the other four are different graphs comparing the TMB values in TCGA categories. Every row in the tsv file contains information about the TMB value of each sample and this file has 3 columns including sample id, number of somatic mutations (after all filter were applied), and the TMB value (For example, a row can be like this: TCGA-02-0003-01A-01D-1490-08    9    0.272727272727273). Examples of the graph files can be found in the images directory.
  
## References:
1. Merino DM, McShane LM, Fabrizio D, Funari V, Chen S, White JR, et al. Establishing guidelines to harmonize tumor mutational burden (TMB): in silico assessment of variation in TMB quantification across diagnostic platforms: phase I of the Friends of Cancer Research TMB Harmonization Project. J Immunother Cancer. 2020 Mar 26;8(1): e000147.
2. Sharma P, Allison JP. Immune Checkpoint Targeting in Cancer Therapy: Towards Combination Strategies with Curative Potential. Cell. 2015 Apr 9;161(2): 205-214.
3. Ellrott K, Bailey MH, Saksena G, Covington KR, Kandoth C, Stewart C, et al. Scalable Open Science Approach for Mutation Calling of Tumor Exomes Using Multiple Genomic Pipelines. Cell Syst. 2018 Mar 28;6(3):271-281.
4. The Concensus CDS of NCBI [internet]. CCDS Database; 2013 Nov [cited 2020 Nov 9]. Available from: https://ftp.ncbi.nlm.nih.gov/pub/CCDS/archive/15/CCDS.20131129.txt
5. TCGA Code Tables [internet]. National Cancer Institute Genomic Data Commons; [cited 2020 Nov 10]. Availbe from: https://gdc.cancer.gov/resources-tcga-users/tcga-code-tables


