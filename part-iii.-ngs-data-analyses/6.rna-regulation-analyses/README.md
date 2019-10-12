# 6.RNA Regulation Analyses

## Table of Contents

* [6.1.RNA editing](rna_editing.md)
* [6.2.APA \(Alternative Polyadenylation\)](apa.md)
* [6.3.Ribo-seq](ribo_seq.md)
* [6.4.Structure-seq](structure_seq.md)
* [6.5.Modification \(m6A-seq\)](6.5.modification-m6a-seq.md)

## Files Needed

### 方法1: 使用docker

6.1 RNA Editing
下载 [bioinfo_rnaeditor.tar.gz](https://lulab2.gitbook.io/teaching/appendix/appendix-iv.-teaching#teaching-docker) 和 [data2_part1.zip data2_part2.zip](https://lulab2.gitbook.io/teaching/appendix/appendix-iv.-teaching#teaching-docker)

启动新的docker.

```bash
docker load -i ~/Desktop/bioinfo_rnaeditor.tar.gz
# 解压数据 (或者双击解压)
unzip data2_part1.zip
unzip data2_part2.zip

#将文件夹中的data2文件合并。
mv data2_part1/data2/ /Users/xugang/Downloads/data2
mv data2_part2/dbSNP.vcf* /Users/xugang/Downloads/data2

#文件目录为/Users/xugang/Downloads/data2,启动时，挂载目录。
#自己运行时记得改为自己的目录地址。
docker run --name=rnaeditor -dt -h bioinfo_docker --restart unless-stopped -v /Users/xugang/Downloads/data2:/data2 gangxu/rnaeditor:1.4
docker exec -it rnaeditor bash
cd /home/test
```
> *  退出容器：`exit`

6.2 APA, 6.3 Ribo-seq, 6.4 Structure-seq
下载 [bioinfo_tsinghua_6.2_apa_6.3_ribo_6.4_structure.tar.gz](https://lulab2.gitbook.io/teaching/appendix/appendix-iv.-teaching#teaching-docker)

启动新的docker.

```bash
docker load -i ~/Desktop/bioinfo_tsinghua_6.2_apa_6.3_ribo_6.4_structure.tar.gz
docker run --name=rnaregulation -dt -h bioinfo_docker --restart unless-stopped -v ~/Desktop/bioinfo_tsinghua_share:/home/test/share gangxu/bioinfo_tsinghua_6.2_apa_6.3_ribo_6.4_structure:latest
docker exec -it rnaregulation bash
cd /home/test/rna_regulation
```
> *  退出容器：`exit`

### 方法2: 直接下载

* 如果不使用docker，也可以直接下载教程所需文件：[Download Link](https://github.com/lulab/teaching_book/tree/master/files/PART_III/)

