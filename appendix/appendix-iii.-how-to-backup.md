# Appendix III. How to Backup

## Scheduled task: crontab
Linux crontab是用来定期执行程序的命令。

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

## Remote data synchronization tool: rsync

## Backup your code: GitHub

## Software: Nutstore


