BiocManager::install("tximport")
#library(DESeq2)
library(tidyverse)
library(RColorBrewer)
library(pheatmap)
library(tximport)
library(ggplot2)
library(ggrepel)


samples <- list.files(path = "/proj/marchlab/projects/EXPORTS/metatranscriptomics/NorthAltantic/alignment/exp1/", full.names = T)
files <- file.path(samples)
names(files) <- str_replace(samples, "/proj/marchlab/projects/EXPORTS/metatranscriptomics/NorthAltantic/alignment/exp1/", "") %>% str_replace(".salmon", "")
tx2gene <- read.delim("/proj/marchlab/projects/EXPORTS/metatranscriptomics/NorthAltantic/annotation/merged_assemblies1_kegg.tsv")
EXPORTStest <- tximport(files, type = "salmon", tx2gene = tx2gene[,c("query","KO")], txOut = TRUE)
EXPORTStest.Rds <- saveRDS(EXPORTStest, file = "/proj/marchlab/projects/txi.keggannot.transcriptlevel.1.rds")



#kegg_tl<-readRDS('txi.keggannot.transcriptlevel.1.rds')
#rownames(kegg_tl) <- kegg_tl$X
#colnames(kegg_tl)[colnames(kegg_tl) == 'X'] <-'query'
#phylodb annotations
#tx2gene1<-read.delim("/proj/marchlab/projects/EXPORTS/StP_Bathycoccus/annotation/Deplete_megaphylodb.tsv")
#import
#txi.phylodb.transcriptlevel<-tximport(files, type="salmon", tx2gene =tx2gene1[,c("TrinityID", "Organism")],txOut=TRUE)
#save r data
#txi.phylodb.transcriptlevel.1.rds<-saveRDS(txi.phylodb.transcriptlevel, "txi.phylodb.transcriptlevel.1.csv")

#phylo<-read.csv('sub.phylo.csv', header=T)
#kegg<-read.csv('sub.phylo.csv', header=T)
#rownames(kegg)<-kegg$X
#colnames(kegg)[colnames(kegg)=='X']<-'TrinityID'

#p<-read.delim('/proj/marchlab/projects/EXPORTS/StP_Bathycoccus/annotation/Deplete_megaphylodb.tsv')
#k<-read.delim('/proj/marchlab/projects/EXPORTS/StP_Bathycoccus/annotation/Deplete_megakegg.tsv')
#colnames(keggannot)[colnames(keggannot)=='query']<-'TrinityID'
#tpmphy<-merge(kegg, p, by ='TrinityID')
#tpmphy<-merge(tpmphy,k, by ='TrinityID')
