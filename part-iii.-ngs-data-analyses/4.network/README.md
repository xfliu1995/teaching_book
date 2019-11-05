# 4.Network

## Table of Contents

* [4.1.Co-expression Network](co_expression.md)
* [4.2.miRNA Targets](4.2.mirna-targets.md)
* [4.3.RBP-RNA Interactions](rbp_interaction.md)

## Files Needed {#files}

### 方法1: 使用docker

### 4.1 Co-expression Network 

docker images的下载链接如[附表](../../appendix/appendix-iv.-teaching.md#teaching-docker)所示，下载 bioinfo-coexp.tar.gz 启动新的docker.

#### 1）Mac

```sh
docker load -i ~/Downloads/bioinfo-coexp.tar.gz # 请根据下载文件的实际位置调整输入内容
mkdir ~/Downloads/data
docker run -dt --name coexpression --restart unless-stopped -v ~/Downloads/data:/data gangxu/coexpression:1.4
```

#### 2) Windows

```sh
docker load -i Downloads\bioinfo-coexp.tar.gz # 请根据下载文件的实际位置调整输入内容
mkdir ~/Downloads/data
docker run -dt --name coexpression --restart unless-stopped -v ~/Downloads/data:/data gangxu/coexpression:1.4
```


加载完我们提供的image后，文件都已经准备好了，可以这样查看：


```bash
docker exec -it coexpression bash
cd /home/bioc
ls
```


> 本教程docker使用方式：
>
> * 1\) 运行容器:  `docker exec -it coexpression bash`
> * 2\) 进行Linux系统的相关操作
> * 3\) 退出容器：`exit`


### 4.2 miRNA target 

```sh

docker load -i ~/Downloads/bioinfo_mirna_target.tar.gz

docker run -dt --name mirna --restart unless-stopped -v ~/Downloads/data:/data mirna_targets:1.0

docker exec -it mirna bash

cd /home/test/mirna
```

### 4.3 RBP-RNA Interactions

```sh

docker load -i ~/Downloads/bioinfo_rbp.tar.gz

docker run -dt --name rbp --restart unless-stopped -v ~/Downloads/data:/data gangxu/bioinfo_rbp:2.0

docker exec -u root -it rbp bash

cd /home/test/rbp
```

> 注意：4.2，4.3的docker安装均以Mac为例，Windows用户请按4.1案例将"docker load -i ~/..."改为"docker load -i ..."

### 方法2: 直接下载

* 如果不使用docker，也可以直接下载教程所需文件：[Download Link](https://github.com/lulab/teaching_book/tree/master/files/PART_III/4.network)

