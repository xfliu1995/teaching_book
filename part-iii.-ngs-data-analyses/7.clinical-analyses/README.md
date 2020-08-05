# 7.Clinical Analyses

## 1\)Table of Contents

* [Survival Analysis](survival_analysis.md)

## 2\) Files Needed

### 2a\) 方法1: 使用docker

docker images的下载链接如[附表](../../appendix/appendix-iv.-teaching.md#teaching-docker)所示，加载完我们提供的image后，文件都已经准备好了，可以这样查看：

```bash
docker load -i ~/Desktop/bioinfo_roc_survival.tar.gz

docker run --name=bioinfo_roc_survival  -dt -h bioinfo_docker --restart unless-stopped -v ~/Downloads/data:/data gangxu/bioinfo_roc_survival:1.0

docker exec -it bioinfo_roc_survival bash

# Survival Analysis

cd /home/test/clinical_analysis
```

### 2b\)方法2: 直接下载

* 如果不使用docker，也可以直接下载教程所需文件：[Download Link](https://github.com/lulab/teaching_book/blob/master/files/PART_III/7.clinical_analyses/README.md)

