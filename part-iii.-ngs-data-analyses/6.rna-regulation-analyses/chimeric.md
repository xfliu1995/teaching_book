# 6.5.Chimeric RNA Detection

本章介绍如何通过RNA-seq找到可能的Chimeric RNAs。

## 1) Background

**Chimeric RNA**, sometimes referred to as a fusion transcript, is composed of exons from two or more different genes that have the potential to encode novel proteins. These RNAs are different from those produced by conventional splicing as they are produced by two or more gene loci.

Chimeric RNA的产生来源包括两种可能的融合，1）两段DNA的融合(Gene Fusion)； 2）两条RNA剪接（trans-splicing) 而成。

## 2) Software

### (1) Install STAR-Fusion

```bash
docker run -dt -v ~/Downloads/ctat_genome_lib_build_X_docker:/data --name=bioinfo_starfusion gangxu/starfusion:latest

docker exec -it bioinfo_starfusion bash
```





## 3) Running STAR-Fusion

STAR-Fusion可以直接以Fastq为输入文件进行融合基因分析；也可以使用STAR的Chimeric.out.junction文件作为STAR-Fusion的输入文件。

下面分别介绍使用这2种不同输入文件进行分析的方法。


### (1) 方法1-输入文件为Chimeric.out.junction

* 使用STAR将Fastq比对到参考基因组上，输出Chimeric.out.junction文件:

```bash
echo STAR start `date`
/usr/local/src/STAR-2.7.2b/bin/Linux_x86_64 \
 --runThreadN 2 \
 --genomeDir /data/ref_genome.fa.star.idx \
 --readFilesIn /data/SRR5712523_1.fastq.gz  /data/SRR5712523_2.fastq.gz \
 --outFileNamePrefix /data/SRR5712523. \
 --outReadsUnmapped None \
 --readFilesCommand "gunzip -c" \
 --outSAMstrandField intronMotif \
 --outSAMunmapped Within \
 --chimSegmentMin 12 \
 --chimJunctionOverhangMin 12 \
 --chimOutJunctionFormat 1 \
 --alignSJDBoverhangMin 10 \
 --alignMatesGapMax 100000 \
 --alignIntronMax 100000 \
 --alignSJstitchMismatchNmax 5 -1 5 5 \
 --outSAMattrRGline ID:SRR5712523 \
 --chimMultimapScoreRange 3 \
 --chimScoreJunctionNonGTAG -4 \
 --chimMultimapNmax 20 \
 --chimNonchimScoreDropMin 10 \
 --peOverlapNbasesMin 12 \
 --peOverlapMMp 0.1 

echo STAR end `date`

```

以Chimeric.out.junction为输入文件，用STAR-Fusion进行融合基因分析

```sh
/usr/local/src/STAR-Fusion/STAR-Fusion --CPU 2 \
--genome_lib_dir /data \
-J /data/SRR5712523.Chimeric.out.junction \
--output_dir /data/SRR5712523_fusion_X_docker
```


### (2) 方法2-输入文件为Fastq

由于STAR运行时会占用较大内存（RAM），约20～30G；如果STAR-Fusion加了`--FusionInspector validate `参数可能会使内存总占用达到～40G，因此当我们从fastq开始使用STAR-fusion分析时需要合理控制并行运行的STAR-Fusion任务数量。

```bash
/usr/local/src/STAR-Fusion/STAR-Fusion \
    --left_fq /data/SRR5712523_1.fastq.gz   \
    --right_fq /data/SRR5712523_2.fastq.gz \
    --genome_lib_dir /data/ \
    -O /data/StarFusionOut \

```

## 4) Utility

在本示例中，我们使用STAR-Fusion进行分析, STAR-Fusion是一款利用RNA-Seq数据检测人类融合基因的软件，STAR-Fusion提供了Docker镜像，以方便用户使用。

如果您不使用Docker镜像而是自行安装，请查看[STAR-Fusion的安装指南](https://github.com/STAR-Fusion/STAR-Fusion/wiki/installing-star-fusion)。

- [STAR-Fusion的GitHub主页](https://github.com/STAR-Fusion/STAR-Fusion/wiki) 有详细的软件使用方法说明

> **Brian J. Haas**, et al. [STAR-Fusion: Fast and Accurate Fusion Transcript Detection from RNA-Seq.](https://www.biorxiv.org/content/10.1101/120295v1) **bioRxiv**, 2017.


其他可以用于分析融合基因的软件有：[Prada](http://bioinformatics.mdanderson.org/main/PRADA:Overview), [FusionCatcher](http://biorxiv.org/content/early/2014/11/19/011650), [SoapFuse](http://soap.genomics.org.cn/soapfuse.html), [TophatFusion](http://ccb.jhu.edu/software/tophat/fusion_index.html), [DISCASM/GMAP-Fusion](https://github.com/DISCASM/DISCASM/wiki)。


### (2) Download reference files for STAR-Fusion

在寻找chimeric RNA时，我们还需要从Broad Institute数据库网站下载STAR-Fusion所需要的参考基因组与注释文件，选择“plug-n-play”压缩文件进行下载。下载地址如下：

https://data.broadinstitute.org/Trinity/CTAT_RESOURCE_LIB/

下载后将其命名为CTAT_resource_lib.tar.gz ，解压。
