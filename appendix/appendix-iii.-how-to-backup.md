# Appendix III. How to Backup

## Basic

### 1\) Cloud storage

* [Tsinghua cloud](https://cloud.tsinghua.edu.cn/) based on seafile 清华云,在校内使用速度快。
* [Nutstore cloud](https://www.jianguoyun.com/) 商业云存储，每个月有免费的备份流量。自己申请账号使用。
* [Nextcloud](http://lulab.life.tsinghua.edu.cn/nextcloud/) 实验室内部搭建的云存储。找实验室管理人员开通账户。

### 2\) Backup tool that comes with the system

**Mac:**  
[Back up your Mac with Time Machine](https://support.apple.com/en-us/HT201250)

**Windows:**  
[How to back up or transfer your data on a Windows-based computer](https://support.microsoft.com/en-us/help/971759/how-to-back-up-or-transfer-your-data-on-a-windows-based-computer)

## Advanced

### 3\) Backup your code on GitHub

**Create your new repository on** [**GitHub**](https://github.com/new)

**create a new repository on the command line**

```bash
echo "# test" >> README.md 
git init 
git add README.md 
git commit -m "first commit" 
git remote add origin https://github.com/xug15/test.git 
git push -u origin master
```

**Download repository**

```bash
git clone https://github.com/xug15/test.git
```

**Save the change of your codes.**

```bash
git add *
git add –u .
git commit -m ‘20190705v1’
```

**Update your codes into the GitHub**

```bash
git push origin master
Username for 'https://github.com': xug15
Password for 'https://xug15@github.com':
```

**Auto update bash**

```bash
time=`date`
echo $time
git add -u .
git add *
git commit -m '$time'
git push origin master
```

**Use** [**GitHub Desktop App**](https://desktop.github.com/)

### 4\) Schedule tasks in Linux: crontab

Linux crontab是用来定期执行程序的命令。

[在线crontab生成器](https://crontab-generator.org/)

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

### 5\) Remote data synchronization tool: rsync

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
| -a: | 以递归方式传输文件 |
| --delete: | 删除那些接收端还有而发送端已经不存在的文件 |
| -q: | 精简输出模式 |
| -z: | 在传输文件时进行压缩处理 |
| -H: | 保持硬链接文件 |
| -t: | 对比两边文件的时间戳和文件大小.如果一致，则就认为两边文件一样，对此文件就不再采取更新动作了 |
| -I: | 挨个文件去发起数据同步 |
| --port=PORT: | 端口号 |

**How to automatically enter a password when logging in to the system**

**1. Generate SSH key**

```bash
ssh-keygen -t rsa -b 2048
```

**2. Copy your keys to the target server:**

```bash
ssh-copy-id user@server_ip # if port add: -p 2200
```

## More

* For advanced users, you can learn [how to back up files using **crontab** and **rsync**](https://lulab.gitbook.io/training/part-i.-programming-skills/3.bash-and-github#example-ii).

## 

