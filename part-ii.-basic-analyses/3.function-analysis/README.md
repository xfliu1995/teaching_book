# 3.Function Analysis

## Table of Contents

* [3.1 GO](3.1.go.md)
* [3.2 KEGG](3.2.kegg.md)
* [3.3 GSEA](3.3.gsea.md)

当我们找到一些感兴趣的基因后（比如在某种处理条件下，与对照相比，表达量有明显差异的基因），我们希望能从这些基因中提炼出生物学意义。

![Fig 1. Overview of existing pathway analysis methods using gene expression data as an example](../../.gitbook/assets/functiona-analysis.png)

我们将会介绍基于差异表达基因的 over representation 分析，包括 GO 富集、KEGG 富集。

另外，我们还将以 GSEA 为代表介绍功能集打分（Functional Class Scroing）方法，其直接分析原始的基因表达矩阵。

更多内容请参考 [Ten Years of Pathway Analysis: Current Approaches and Outstanding Challenges](https://doi.org/10.1371/journal.pcbi.1002375)

## Files Needed

### 方法1: 使用docker

加载完我们提供的image后，文件都已经准备好了，可以这样查看：

```bash
cd /home/test/
ls
```

> 本教程docker使用方式：
>
> * 1\) 运行容器:  `docker exec -it bioinfo_tsinghua bash`
> * 2\) 进行Linux系统的相关操作
> * 3\) 退出容器：`exit`

### 方法2: 直接下载

* 如果不使用docker，也可以直接下载教程所需文件：[Download Link](https://github.com/lulab/teaching_book/tree/master/files/PART_II)

