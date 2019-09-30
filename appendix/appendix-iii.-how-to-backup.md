# Appendix III. How to Backup

## Basic

### 1\) Cloud storage

* [Tsinghua cloud](https://cloud.tsinghua.edu.cn/) based on seafile 清华云,在校内使用速度快。
* [Nutstore cloud](https://www.jianguoyun.com/) 商业云存储，每个月有免费的备份流量。自己申请账号使用。
* [Nextcloud](http://lulab.life.tsinghua.edu.cn/nextcloud/) 实验室内部搭建的云存储。找实验室管理人员开通账户。

### 2\) Backup tool that comes with the system

* **Mac:**  [Back up with Time Machine](https://support.apple.com/en-us/HT201250)

* **Windows:** [Back up on a Windows-based computer](https://support.microsoft.com/en-us/help/971759/how-to-back-up-or-transfer-your-data-on-a-windows-based-computer)



### 3a) Backup your code with GitHub

* Create and edit your repositories (repos.) at [**GitHub**](https://github.com) on line
* Use [**GitHub Desktop App**](https://desktop.github.com/) to sync your local projects (code) with Github repos.



## Advanced

### 3b\) Backup your code with GitHub in Terminal

* **Setup**
  * [**set up ssh-key**](#40-setup-ssh-key-optional)  (optinal)
  * **add a setting file:** ~/.gitconfig

```bash
[user] 
email =[NNN@NN.com]
name = Shared
```

* **Clone/Download an existed repository on github**

```bash
git clone git@github.com:lulab/RNAfinder_Server.git
git clone https://github.com/xug15/test.git
```

* **Create a new repository**

```bash
echo "# test" >> README.md 
git init 
git add README.md 
git commit -m "first commit" 
git remote add origin https://github.com/xug15/test.git 
git push -u origin master
```

* **Sync local files with github repo**

**Pull (update)**:

```bash
git pull origin master
git log -n 2 # look at the last two log entries.
```

**Add:**

```bash
git add exmaples/
git commit -m ‘20190705v1’
git push origin
```

**Change:**

```bash
git commit -m ‘20190705v1’
git push origin
```

**Remove:**

```bash
git rm *.file
git commit -m ‘20190705v1’
git push origin
```



> **Tips:** 
> the bash script to sync a github repo:
>
> ```bash
> time=`date`
> echo $time
> git add -u .
> git add *
> git commit -m '$time'
> git push origin master
> ```





### 4) Backup data using rsync and crontab

#### 4.0) Setup ssh key (optional)

* (a) Generate SSH key

```bash
ssh-keygen -t rsa -b 2048
```

* (b) Copy your keys to the target server

```bash
ssh-copy-id user@server_ip    #if port add: -p 2200
```

> **上述操作后，通过ssh到remote server时就可以无需输入密码了，因此下面的步骤也可以在无人值守的时候自动运行。**
>
> **但如果下面的步骤中你无需登录remote server, 就无需setup ssh key。**



#### 4.1) Prepare a backup script with rsync

* (a) First you need to prepare some backup dirs

```bash
mkdir /home/john/backup_local    # prepare a backup dir for some local files
mkdir /home/john/backup_remote   # prepare a backup dir for some remote files
```
* (b) Then, write a back up script, for example : ~/backup.sh

```bash
#!/bin/bash

#0. Define the parameters of rsync
RSYNC="rsync --stats  --compress --recursive --times --perms --links --delete --max-size=100M --exclude-from=/home/john/excluded_file_list.txt"

#A. Local backup  
echo "1. Backup of /home/john/data start at:"
date
$RSYNC /home/john/data/  /home/john/backup_local/
echo "Backup end at:"
date

#B. Remote backup 
echo "2. Backup 166.178.56.20:/home/lulab/john/data/ start at:"
date
$RSYNC john@166.178.56.20:/home/lulab/john/data/ /home/john/backup_remote/
echo "Backup end at:"
date
```

* (c) Last, make your backup.sh excutable

```bash
chmod +x ~/backup.sh
```

> **Parameters of rsync** (use `man rsync` to see more details): 
>
> | Parameter    | Mean                                                         |
>| :----------- | :----------------------------------------------------------- |
> | -a:          | 以递归方式传输文件                                           |
> | --delete:    | 删除那些接收端还有而发送端已经不存在的文件                   |
> | -q:          | 精简输出模式                                                 |
> | -z:          | 在传输文件时进行压缩处理                                     |
> | -H:          | 保持硬链接文件                                               |
> | -t:          | 对比两边文件的时间戳和文件大小.如果一致，则就认为两边文件一样，对此文件就不再采取更新动作了 |
> | -I:          | 挨个文件去发起数据同步                                       |
> | --port=PORT: | 端口号                                                       |
> 



#### 4.2) Schedule the back tasks with crontab

crontab是Linux中用来定期执行程序的命令, 你可以使用 [在线crontab生成器](https://crontab-generator.org/)，也可以按如下方式自己编辑：

- 打开crontab编辑器：

```
crontab -e
```

- 加入以下行：

```bash
# minute hour day_in_month month day_in_week command
15 3 * * * /home/john/backup.sh > /home/john/backup.log
```

>  Linux将通过**crontab**定时运行上述命令, 具体定义如下：
>
> | Column    | Mean                               |
> | :-------- | :--------------------------------- |
> | Column 1: | Minutes 0 to 59                    |
> | Column 2: | Hours 0 to 23 \(0 means midnight\) |
> | Column 3: | Day 1 to 31                        |
> | Column 4: | Months 1~12                        |
> | Column 5: | Week 0 to 7 \(0 and 7 for Sunday\) |
> | Column 6: | Command to run                     |



### 5) More Reading for advanced users

* 《[鸟哥的Linux私房菜-基础学习篇](https://www.ctolib.com/docs/sfile/vbird-linux-basic-4e)》 \(25章推荐章节\)

  > **Linux 推荐章节：**
  >
  > - 第25章 LINUX备份策略: 25.2.2完整备份的差异备份; 25.3鸟哥的备份策略; 25.4灾难恢复的考虑; 25.5重点回顾



