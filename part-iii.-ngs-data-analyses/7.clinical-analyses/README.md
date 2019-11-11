# 7.Clinical Analyses

## Table of Contents

* [7.1.ROC Curve](roc_curve.md)
* [7.2.PCA/tSNE](pca_tsne.md)
* [7.3.Survival Analysis](survival_analysis.md)

## Files Needed

### 方法1: 使用docker

docker images的下载链接如[附表](../../appendix/appendix-iv.-teaching.md#teaching-docker)所示，加载完我们提供的image后，文件都已经准备好了，可以这样查看：
 
 7.1 ROC Curve, 7.3 Survival Analysis
 
```bash
docker load -i ~/Desktop/bioinfo_roc_survival.tar.gz

docker run --name=roc -dt -h bioinfo_docker --restart unless-stopped -v ~/Downloads/data:/data gangxu/bioinfo_roc_survival:1.0

docker exec -it roc bash

# 7.1 ROC Curve

cd /home/test/roc

# 7.3 Survival Analysis

cd /home/test/clinical_analysis

```


```sh

```

> 本教程docker使用方式：
>
> * 1\) 运行容器:  `docker exec -it roc bash`
> * 2\) 进行Linux系统的相关操作
> * 3\) 退出容器：`exit`

### 方法2: 直接下载

* 如果不使用docker，也可以直接下载教程所需文件：[Download Link](https://github.com/lulab/teaching_book/blob/master/files/PART_III/7.clinical_analyses/README.md)

