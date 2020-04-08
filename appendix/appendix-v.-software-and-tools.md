# Appendix V. Software and Tools

## Software for the ages

| Software | Purpose | Creators | Key capabilities | Year released | Citationsa |
| :--- | :--- | :--- | :--- | :---: | :---: |
| BLAST | Sequence alignment | Stephen Altschul, Warren Gish, Gene Myers, Webb Miller, David Lipman | First program to provide statistics for sequence alignment, combination of sensitivity and speed | 1990 | 35,617 |
| R | Statistical analyses | Robert Gentleman, Ross Ihaka | Interactive statistical analysis, extendable by packages | 1996 | N/A |
| ImageJ | Image analysis | Wayne Rasband | Flexibility and extensibility | 1997 | N/A |
| Cytoscape | Network visualization and analysis | Trey Ideker _et al_. | Extendable by plugins | 2003 | 2,374 |
| Bioconductor | Analysis of genomic data | Robert Gentleman _et al_. | Built on R, provides tools to enhance reproducibility of research | 2004 | 3,517 |
| Galaxy | Web-based analysis platform | Anton Nekrutenko, James Taylor | Provides easy access to high-performance computing | 2005 | 309b |
| MAQ | Short-read mapping | Heng Li, Richard Durbin | Integrated read mapping and SNP calling, introduced mapping quality scores | 2008 | 1,027 |
| Bowtie | Short-read mapping | Ben Langmead, Cole Trapnell, Mihai Pop, Steven Salzberg | Fast alignment allowing gaps and mismatches based on Burrows-Wheeler Transform | 2009 | 1,871 |
| Tophat | RNA-seq read mapping | Cole Trapnell, Lior Pachter, Steven Salzberg | Discovery of novel splice sites | 2009 | 817 |
| BWA | Short-read mapping | Heng Li, Richard Durbin | Fast alignment allowing gaps and mismatches based on Burrows-Wheeler Transform | 2009 | 1,556 |
| Circos | Data visualization | Martin Krzywinski _et al_. | Compact representation of similarities and differences arising from comparison between genomes | 2009 | 431 |
| SAMtools | Short-read data format and utilities | Heng Li, Richard Durbin | Storage of large nucleotide sequence alignments | 2009 | 1,551 |
| Cufflinks | RNA-seq analysis | Cole Trapnell, Steven Salzberg, Barbara Wold, Lior Pachter | Transcript assembly and quantification | 2010 | 710 |
| IGV | Short-read data visualization | James Robinson _et al_. | Scalability, real-time data exploration | 2011 | 335 |
| N/A, paper not available in Web of Science. |  |  |  |  |  |

> From: [The anatomy of successful computational biology software](https://www.nature.com/articles/nbt.2721)

## 1\) Genome Browser

* [IGV](http://software.broadinstitute.org/software/igv/)
* [UCSC Genome Browser](https://genome.ucsc.edu/)

## 2\) DNA-seq

### \(2.1\) Mapping and QC

* **Mapping**: Bowtie, STAR
* **QC**: fastqc 

### \(2.2\) Mutation

* **Software Package**: [GATK](https://gatk.broadinstitute.org/hc/en-us)

### \(2.3\) Assembly

## 3\) RNA-seq

### \(3.1\) RNA-seq

* **Expression Matrix:** 
* **Differential Expression**: DESEQ2, EdgeR
* **Alternative Splicing**: 
* **RNA Editing**: 
* ...

### \(3.2\) Single Cell RNA-seq \(scRNA-seq\)

* **Selected  Software providers for scRNA-seq analysis**

> [Nature Biotechnology 2020 38\(3\):254-257](https://www.nature.com/articles/s41587-020-0449-8)

| Software name | Developer | Price structure | Platform-specific | Relevant stages of experiment |
| :--- | :--- | :--- | :--- | :--- |
| [Cell Ranger](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/what-is-cell-ranger) | 10X Genomics | Free download | 10X Chromium | Raw read alignment, QC and matrix generation for scRNA-seq and ATAC-seq; data normalization; dimensionality reduction and clustering |
| [Loupe Cell Browser](https://support.10xgenomics.com/single-cell-gene-expression/software/visualization/latest/what-is-loupe-cell-browser) | 10X Genomics | Free download | 10X Chromium | Visualization and analysis |
| [Partek Flow](https://www.partek.com/application-page/single-cell-gene-expression/) | Partek | License | No | Complete data analysis and visualization pipeline for scRNA-seq data |
| [Qlucore Omics Explorer](https://www.qlucore.com/single-cell-rnaseq) | Qlucore | License | No | scRNA-seq data filtering, dimensionality reduction and clustering, visualization |
| [mappa Analysis Pipeline](https://www.takarabio.com/products/automation-systems/icell8-system-and-software/bioinformatics-tools/mappa-analysis-pipeline) | Takara Bio | Free download | Takara ICell8 | Raw read alignment and matrix generation for scRNA-seq |
| [hanta R kit](https://www.takarabio.com/products/automation-systems/icell8-system-and-software/bioinformatics-tools/hanta-r-kit) | Takara Bio | Free download | Takara ICell8 | Clustering and analysis of mappa data |
| [Singular Analysis Toolset](https://www.fluidigm.com/software) | Fluidigm | Free download | Fluidigm C1 or Biomark | Analysis and visualization of differential gene expression data for scRNA-seq |
| [SeqGeq](https://www.flowjo.com/solutions/seqgeq) | FlowJo/BD Biosciences | License | No | Data normalization and QC, dimensionality reduction and clustering, analysis and visualization |
| [Seven Bridges](https://www.sevenbridges.com/bdgenomics/) | Seven Bridges/BD Biosciences | License | BD Rhapsody and Precise | Cloud-based raw read alignment, QC and matrix generation |
| [Tapestri Pipeline/Insights](https://missionbio.com/panels/software/) | Mission Bio | Free download | Mission Bio Tapestri | Analysis of single-cell genomics data |
| [BaseSpace SureCell](https://www.illumina.com/products/by-type/informatics-products/basespace-sequence-hub.html) | Illumina | License | Illumina SureCell libraries | Raw read alignment and matrix generation |
| [OmicSoft Array Studio](https://omicsoftdocs.github.io/ArraySuiteDoc/tutorials/scRNAseq/Introduction/) | Qiagen | License | No | Raw read alignment, QC and matrix generation, dimensionality reduction and clustering |

> QC, quality control; ATAC-seq, assay for transposase-accessible chromatin using sequencing.

## 4\) Interactome

### **\(4.1\) ChIP-seq**

### **\(4.2\) CLIP-seq**

### **\(4.3\) Motif analysis**

**sequence**

1. MEME motif based sequence analysis tools [http://meme-suite.org/](http://meme-suite.org/)
2. HOMER Software for motif discovery and next-gen sequencing analysis [http://homer.ucsd.edu/homer/motif/](http://homer.ucsd.edu/homer/motif/)

**structure**

1. RNApromo Computational prediction of RNA structural motifs involved in post transcriptional regulatory processes [https://genie.weizmann.ac.il/pubs/rnamotifs08/](https://genie.weizmann.ac.il/pubs/rnamotifs08/)
2. GraphProt modeling binding preferences of RNA-binding proteins [http://www.bioinf.uni-freiburg.de/Software/GraphProt/](http://www.bioinf.uni-freiburg.de/Software/GraphProt/)

## 5\) Epigenetic Data

* **DNA Methylation** 
  * **Bi-sulfate data**:
  * **IP data**:
* **DNAase-seq**: 
* **ATAC-seq**:

## 6\) Chromatin and Hi-C

## More: Lu Lab shared tools and scripts

* Scripts:  [Lu Lab](https://github.com/lulab/shared_scripts) \| [Zhi J. Lu](https://github.com/urluzhi/scripts) 
* Plots: [Lu Lab](../part-i.-basic-skills/3.r/3.2.plots-with-r.md) \| [Zhi J. Lu](https://github.com/urluzhi/scripts/tree/master/Rscript/R_plot)

