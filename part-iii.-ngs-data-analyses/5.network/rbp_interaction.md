# 5.3.RBP-RNA Interactions

## 1\) Background

CLIP-seq \(crosslinking-immunprecipitation and high-throughput sequencing\),是一项全基因组水平揭示RNA分子与RNA结合蛋白相互作用的革命性技术。其主要原理是基于RNA分子与RNA结合蛋白在紫外照射下发生耦联，以RNA结合蛋白的特异性抗体将RNA-蛋白质复合体沉淀之后，回收其中的RNA片段，经添加接头、RT-PCR等步骤，对这些分子进行高通量测序，再经生物信息学的分析和处理、总结，挖掘出其特定规律，从而深入揭示RNA结合蛋白与RNA分子的调控作用及其对生命的意义。

POSTAR2数据库中收集了大量的CLIP-seq,并用统一的生物信息学流程鉴定出RBP的结合位点，可以从该数据库中下载得到不同物种里，大量RBP在不同的细胞系、组织或者发育阶段的结合位点。

## 2\) workflow

![](../../.gitbook/assets/rbp.pipeline.png)

## 3\) RBP enrichment

### 3a\) get CLIP-seq data

[文件和软件获取方式](./#files) （我们在 [docker](./#files) 中已提供了下载好的示例文件）

> * 数据来源： [POSTAR2](http://lulab.life.tsinghua.edu.cn/postar/download.php)
> * 为保证CLIP-seq方法的统一和取出较小的文件方便大家练习，我们从human RBP binding sites中提取第八列为eCLIP得到的文件，得到一个较小的文件： `human_RBP_eCLIP_hg38.txt`。

* 文件示例（human\_RBP\_eCLIP\_hg38.txt）:

```text
chr1    187044  187087  human_RBP_eCLIP_ENCODE_1        0       -       AARS    eCLIP   K562    ENCODE  3.02982873699729
chr1    267418  267466  human_RBP_eCLIP_ENCODE_2        0       -       AARS    eCLIP   K562    ENCODE  5.50800008227284
chr1    630751  630792  human_RBP_eCLIP_ENCODE_3        0       -       AARS    eCLIP   K562    ENCODE  3.5454755693998
```

* explanation for each column:

```text
column1:chromosome
column2:peak start 
column3:peak end
column4:name
column5:0
column6:strand
column7:RBP name
column8:CLIP-seq technology, peak calling method
column9:cell line or tissue
column10:data accession
column11:score(Piranha score: Peak heights from the CLIP-seq data; PARalyzer score: T-to-C transition ratios ranging from 0 to 1, ratios greater than 0.5 indicate protein-binding while less than 0.5 indicate without protein-binding; CIMS score: Mismatch peak heights from the CLIP-seq data; CITS score: Truncated peak heights from the CLIP-seq data; eCLIP score: -log10 P-value, the threshold is 3.)
```

### 3b\) prepare interested bed and background bed

#### interested bed

up.bed

```text
chr1    1167104 1167134 ENSG00000207730.3__1167104__1167134__1  .       +
chr1    1167119 1167149 ENSG00000207730.3__1167119__1167149__2  .       +
chr1    1167134 1167164 ENSG00000207730.3__1167134__1167164__3  .       +
```

#### prepare background bed from interested bed

the same as method in sequence\_motif \(1\) downstream/upstream 1000bp \(2\) shuffle the input sequence \(3\) shuffle the genome sequence

### 3c\) overlap between CLIP-seq peaks and interested/background bed

use intersectBed \(bedtools\) command to get the overlaps of CLIP-seq peaks

```text
cd /home/test/rbp

intersectBed -wa -wb -s -a up.bed -b human_RBP_eCLIP_hg38.txt >up.eCLIP.hg38.txt
intersectBed -wa -wb -s -a up_background.bed -b human_RBP_eCLIP_hg38.txt >up_background.eCLIP.hg38.txt
```

### 3d\) compare RBP enrichment

#### percentage of region with CLIP-seq peaks

```text
cut -f 4 up.bed |sort -u|wc -l
1685
cut -f 4 up.eCLIP.hg38.txt |sort -u|wc -l
663
cut -f 4 up_background.bed |sort -u|wc -l
1685
cut -f 4 up_background.eCLIP.hg38.txt |sort -u|wc -l
544
```

#### RBP enrichment in each region

```text
cat <(cut -f 4,13 up.eCLIP.hg38.txt |sort -u|cut -f 1|sort|uniq -c|sed 's/^[ \t]*//g'|sed 's/ /\t/g'|awk 'BEGIN{FS="\t";OFS="\t"}{print $1,$2,"up"}') <(cut -f 4,13 up_background.eCLIP.hg38.txt |sort -u|cut -f 1|sort|uniq -c|sed 's/^[ \t]*//g'|sed 's/ /\t/g'|awk 'BEGIN{FS="\t";OFS="\t"}{print $1,$2,"up_bg"}')|sed '1i density\tname\tclass' >RBP_enrichment.txt
```

screen short of "RBP\_enrichment.txt"

```text
density name    class
1       ENSG00000004897.11__47141883__47141913__96      up
2       ENSG00000104723.20__15540418__15540448__14      up
2       ENSG00000115758.12__10441554__10441584__100     up
```

boxplot of RBP enrichment

```text
R
library(ggplot2)
library(reshape2)

data    =       read.table('/home/test/rbp/RBP_enrichment.txt',head=T);
pdf('/home/test/rbp/rbp_enrichment.pdf',width=3,height=6);

attach(data)
boxplot(density~class,data=data,outline=F,col=c("red","gray"))
dev.off()

q()
# Save workspace image? [y/n/c]: n

# Enter
```

![](../../.gitbook/assets/rbp_enrichment.png)

## 3\) Homework

* 根据提供的上调gene的ID,自己准备作为比较的背景gene,并详细写清楚得到背景gene的步骤；比较这些上调gene和背景gene的3‘UTR区域RBP的富集程度；最后提交每一步的代码和相应的图。相应的文件在本章节的[homework](https://github.com/lulab/teaching_book/tree/master/files/PART_III/4.network/RBP_interaction/RBP_interaction.homework)文件夹下。

