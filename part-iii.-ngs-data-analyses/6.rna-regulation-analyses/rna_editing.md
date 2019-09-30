# 6.1.RNA Editing

## 1\) Background

Pre-mRNA molecules transcribed from the genome may fold to form double-stranded RNA \(dsRNA\) secondary structures. dsRNA-specific adenosine deaminase \(ADAR\) enzymes bind these structures and deaminate some adenosines to inosines. If these inosines are located in an exon, they will be present in the mature mRNA.

![](../../.gitbook/assets/rna_editing.f1.png)

Reverse transcription replaces inosines in mRNA with guanosines in the cDNA. Thus, the hallmark of RNA editing is a consistent A → G mismatch between RNA sequencing \(RNA-seq\) data and the reference genomic sequence to which it is aligned.

![](../../.gitbook/assets/rna_editing.f2.png)

Four main types of mRNA editing have been studied in recent decades. A-to-I RNA editing is the most common in terms of the range of organisms affected, the breadth of tissues edited and the number of editing sites.

![](../../.gitbook/assets/rna_editing.f3.png)

Editing can modify protein function, generate new protein products and alter gene regulation.

![](../../.gitbook/assets/rna_editing.f4.png)

## 2\) Paper

RNAEditor: easy detection of RNA editing events and the introduction of editing islands

## 3\) pipeline

![](../../.gitbook/assets/rna_editing.f5.png)

## 4\) Website

[http://rnaeditor.uni-frankfurt.de/index.php](http://rnaeditor.uni-frankfurt.de/index.php)

download software and annotation files in the "Install" and "Download annotations" page.

## 5\) Running steps

### \(1\) input
#### 1. fastq file
#### 2. configuration file
A brief look of configuration file
```
# This file is used to configure the behaviour of RNAeditor

# Standard input files
refGenome = ~/rnaEditor_annotations/human/GRCH38/Homo_sapiens.GRCh38.dna.primary_assembly.fa
gtfFile = ~/rnaEditor_annotations/human/GRCH38/Homo_sapiens.GRCh38.83.gtf
dbSNP = ~/rnaEditor_annotations/human/GRCH38/dbSNP_ensemble2.vcf
hapmap = ~/rnaEditor_annotations/human/GRCH38/HAPMAP.vcf
omni = ~/rnaEditor_annotations/human/GRCH38/1000GenomeProject.vcf
esp = ~/rnaEditor_annotations/human/GRCH38/ESP.vcf
aluRegions = ~/rnaEditor_annotations/human/GRCH38/repeats.bed
output = default
sourceDir = /usr/local/bin/
maxDiff = 0.04
seedDiff = 2
standCall = 0
standEmit = 0
edgeDistance = 3
intronDistance = 5
minPts = 5
eps = 50
paired = False
keepTemp = True
overwrite = False
threads = 5
```
#### 3. starting analysis
```text
RNAEditor -i sample.fq -c configuration.txt
```

## 6\) Homework
参照RNAEditor网页上[Documentation](http://rnaeditor.uni-frankfurt.de/documentation.php)页面，理解示例文件运行完的输出结果中sample.vcf和sample.gvf的含义。根据sample.gvf文件，统计RNA编辑位点在基因组上的分布（3‘UTR,intron等各不同区域各有多少RNA editing sites,用柱形图展示）；计算每个RNA编辑位点的editing ratio。

## 7\) Reference
1. A-to-I RNA editing — immune protector and transcriptome diversifier. Eli Eisenberg, et al. Nature Reviews, 2018.
2. RNAEditor: easy detection of RNA editing events andthe introduction of editing islands. David John, et al. Briefings in Bioinformatics, 2017.

