### for ploting DE analysis result chart
## 1. Load the CummeRbund package into the R environment:
library(cummeRbund)
## 2.Create a CummeRbund database from the Cuffdiff output:
cuff_data <- readCufflinks('1M_reads_diff_expr')
## 3. Plot the distribution of expression levels for each sample (Fig. 6):
# save the plot in a pdf file:
pdf("1M_reads_diff_expr/density_plot.pdf")
csDensity(genes(cuff_data))
dev.off()

## 4.Compare the expression of each gene in two conditions with a scatter plot (Fig. 7):
# sample names here are q1 and q2, find help by typing: ?csScatter()
pdf("1M_reads_diff_expr/scatter_plot.pdf")
csScatter(genes(cuff_data), 'q1', 'q2')
dev.off()
## 5. Create a volcano plot to inspect differentially expressed genes (Fig. 8):
pdf("1M_reads_diff_expr/volcano_plot.pdf")
csVolcano(genes(cuff_data), 'q1', 'q2')
dev.off()
## 6. Plot expression levels for genes of interest with bar plots (Fig. 9a):
pdf("1M_reads_diff_expr/BDH1_bar_plot_gene.pdf")
mygene <- getGene(cuff_data,'BDH1')
expressionBarplot(mygene)
dev.off()
## 7. Plot individual isoform expression levels of selected genes of interest with bar plots (Fig. 9b):
pdf("1M_reads_diff_expr/BDH1_bar_plot_isoform.pdf")
expressionBarplot(isoforms(mygene))
dev.off()
## other steps please reference to the Trapnell's Protocol
