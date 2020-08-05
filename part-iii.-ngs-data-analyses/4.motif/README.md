# 4.Motif

## 1\)Table of Contents

* [5.1.Sequence Motif](sequence_motif.md)
* [5.2.Structure Motif](structure_motif.md)

## 2\)Files Needed <a id="files"></a>

### 2a\)方法1: 使用docker

docker images的下载链接如[附表](../../appendix/appendix-iv.-teaching.md#teaching-docker)所示，加载完我们提供的image后，文件都已经准备好了，可以这样查看：

```bash
docker load -i bioinfo_motif.tar.gz

docker run -dt --name motif --restart unless-stopped -v ~/Downloads/data:/data gangxu/motif:1.0
```

> 本教程docker使用方式：
>
> * 1\) 运行容器:  `docker exec -it motif bash`
> * 2\) 进行Linux系统的相关操作
> * 3\) 退出容器：`exit`

### 2b\)方法2: 直接下载

* 如果不使用docker，也可以直接下载教程所需文件：[Download Link](https://github.com/lulab/teaching_book/tree/master/files/PART_III/5.motif)

