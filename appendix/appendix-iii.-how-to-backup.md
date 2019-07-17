# Appendix III. How to Backup

## Scheduled task: crontab

Linux crontab是用来定期执行程序的命令。

**Edit .bashrc file in the $HOME directory**

```bash
EDITOR=vi; export EDITOR
```

**Create a file called usercron \(space separated\)**

```bash
15 1 * * * /bin/echo 'date' > /dev/console
```

**Running file**

```bash
crontab usercron
```

| Column | Mean |
| :--- | :--- |
| Column 1: | Minutes 0 to 59 |
| Column 2: | Hours 0 to 23 \(0 means midnight\) |
| Column 3: | Day 1 to 31 |
| Column 4: | Months 1~12 |
| Column 5: | Week 0 to 7 \(0 and 7 for Sunday\) |
| Column 6: | Command to run |

**Execute my Command every 1 minute**

```bash
* * * * * Command
```

**Execute at 3 and 15 minutes from 1 am**

```bash
3,15 1 * * * Command
```

**Restart smb at 1:30 every night**

```bash
30 1 * * * /etc/init.d/smb restart
```

**List the crontab file with the -l parameter:**

```bash
$ crontab -l
0,15,30,45 18-06 * * * /bin/echo `date` > dev/tty1
```

**Edit crontab file**

```bash
$ crontab -e
```

**crontab file to make a backup**

```bash
$ crontab -l > $HOME/mycron
```

## Remote data synchronization tool: rsync

rsync命令是一个远程数据同步工具，可通过LAN/WAN快速同步多台主机间的文件。

**Synchronize data on local disk**
```bash
rsync -a --delete /home /backups 
```

**Perform a "push" copy sync**
```bash
rsync /etc/hosts user@172.22.220.21:/home/xugang/hosts
```

**Perform a "pull" replication synchronization**
```bash
rsync user@172.22.220.21:/home/xugang/hosts /etc/hosts
rsync -aqzH --delete --delay-updates \ 
user@172.22.220.21:/home/xugang/hosts /etc/hosts
```

**mirror centos at 0:10 AM everyday**
```bash
10 0 * * * rsync -aqzH –delete \
 --delay-updates user@172.22.220.21:/home/xugang/hosts /etc/hosts
```

| Parameter | Mean |
| :--- | :--- |
|-a:| 以递归方式传输文件|
|--delete:| 删除那些接收端还有而发送端已经不存在的文件|
|-q:| 精简输出模式|
|-z:| 在传输文件时进行压缩处理|
|-H:| 保持硬链接文件|
|-t:| 对比两边文件的时间戳和文件大小.如果一致，则就认为两边文件一样，对此文件就不再采取更新动作了|
|-I:| 挨个文件去发起数据同步|
|--port=PORT:| 端口号|


## Backup your code: GitHub

## Software: Nutstore

