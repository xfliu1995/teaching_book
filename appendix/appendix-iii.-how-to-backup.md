# Appendix III. How to Backup

## Scheduled task: crontab
Linux crontab是用来定期执行程序的命令。

-------

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
----

|Column| Mean |
|--    |--    |
|Column 1:| Minutes 0 to 59|
|Column 2:| Hours 0 to 23 (0 means midnight)|
|Column 3:| Day 1 to 31|
|Column 4:| Months 1~12|
|Column 5:| Week 0 to 7 (0 and 7 for Sunday)|
|Column 6:| Command to run|



## Remote data synchronization tool: rsync

## Backup your code: GitHub

## Software: Nutstore


