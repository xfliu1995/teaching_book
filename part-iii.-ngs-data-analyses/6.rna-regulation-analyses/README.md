# 6.RNA Regulation Analyses

## Table of Contents

* [6.1.RNA editing](rna_editing.md)
* [6.2.APA \(Alternative Polyadenylation\)](apa.md)
* [6.3.Ribo-seq](ribo_seq.md)
* [6.4.Structure-seq](structure_seq.md)
* [6.5.Gene fusion dection from RNA-seq](gene_fusion_RNA-seq.md)
* [6.6.SNV detection from RNA-seq](SNV_RNA-seq.md)

  

## Files Needed {#files}

### 方法1: 使用docker

docker images的下载链接如[附表](../../appendix/appendix-iv.-teaching.md#teaching-docker)所示，本大章包括2个images：

(1) **6.1 RNA Editing**: bioinfo_rnaeditor.1.8.tar.gz


```bash
docker load -i ~/Desktop/bioinfo_rnaeditor.tar.gz

#注意：下面的文件挂载目录为/Users/xugang/Downloads/data2, 自己运行时记得改为自己新建的一个目录名称。
docker run --name=rnaeditor -dt -h bioinfo_docker --restart unless-stopped -v /Users/xugang/Downloads/data2:/data2 gangxu/rnaeditor:1.8

docker exec -it rnaeditor bash

cd /home/test
```


(2) **6.2 APA, 6.3 Ribo-seq, 6.4 Structure-seq**：bioinfo_tsinghua_6.2_apa_6.3_ribo_6.4_structure.tar.gz

```bash
docker load -i ~/Desktop/bioinfo_tsinghua_6.2_apa_6.3_ribo_6.4_structure.tar.gz

#注意：下面的文件挂载目录为~/Desktop/bioinfo_tsinghua_share, 自己运行时记得改为自己新建的一个目录名称。
docker run --name=rnaregulation -dt -h bioinfo_docker --restart unless-stopped -v ~/Desktop/bioinfo_tsinghua_share:/home/test/share gangxu/bioinfo_tsinghua_6.2_apa_6.3_ribo_6.4_structure:latest

docker exec -u root -it rnaregulation bash


# APA
cd /home/test/rna_regulation/apa

# Ribo-seq
cd /home/test/rna_regulation/ribo-wave

# Structure-seq
cd /home/test/rna_regulation/structure_seq
```


### 方法2: 直接下载

* 如果不使用docker，也可以直接下载教程所需文件：[Download Link](https://github.com/lulab/teaching_book/tree/master/files/PART_III/6.RNA_Regulation)

