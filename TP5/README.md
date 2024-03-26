# TP5 : We do a little scripting

## I. Service SSH

### 1. Analyse du service

```powershell
[solar@tp5 ~]$ /srv/idcard/idcard.sh
Machine name : tp5
OS Linux and kernel version is 5.14.0-284.11.1.el9_2.x86_64
IP : 10.1.5.5
RAM : 56Mi memory available on 771Mi total memory
Disk : 16G space left
Top 5 processes by RAM usage :
- node
- node
- node
- node
- python3
Listening ports :
- 41507 tcp
- 22 tcp
- 22 tcp
PATH directories :
- /home/solar/.local/bin
- /home/solar/bin
- /usr/local/bin
- /usr/bin
- /usr/local/sbin
- /usr/sbin
Here is your random cat (JPEG file) : https://cdn2.thecatapi.com/images/677.jpg
```

## II. Script youtube-dl

### 1. Premier script youtube-dl

```powershell
[solar@tp5 yt]$ ./yt.sh https://www.youtube.com/watch?v=k85mRPqvMbE
Video https://www.youtube.com/watch?v=k85mRPqvMbE was downloaded.
File path : srv/yt/downloads/Crazy Frog - Axel F (Official Video)/Crazy Frog - Axel F (Official Video).mp4
```

### 2. MAKE IT A SERVICE

```powershell
[solar@tp5 system]$ systemctl status yt
● yt.service - Service for download youtube video
     Loaded: loaded (/etc/systemd/system/yt.service; enabled; preset: disabled)
     Active: active (running) since Tue 2024-03-05 11:25:12 CET; 9min ago
   Main PID: 3279 (yt-v2.sh)
      Tasks: 2 (limit: 4674)
     Memory: 600.0K
        CPU: 324ms
     CGroup: /system.slice/yt.service
             ├─3279 /bin/bash /srv/yt/yt-v2.sh
             └─3364 sleep 10

Mar 05 11:33:22 tp5 yt-v2.sh[3279]: The file of URL is empty or doesn't exist.
Mar 05 11:33:32 tp5 yt-v2.sh[3279]: The file of URL is empty or doesn't exist.
Mar 05 11:33:42 tp5 yt-v2.sh[3279]: The file of URL is empty or doesn't exist.
Mar 05 11:33:52 tp5 yt-v2.sh[3279]: The file of URL is empty or doesn't exist.


[solar@tp5 system]$ journalctl -xe -u yt
Mar 05 11:27:22 tp5 yt-v2.sh[3279]: The file of URL is empty or doesn't exist.
Mar 05 11:27:32 tp5 yt-v2.sh[3279]: The file of URL is empty or doesn't exist.
Mar 05 11:27:42 tp5 yt-v2.sh[3279]: The file of URL is empty or doesn't exist.
Mar 05 11:27:52 tp5 yt-v2.sh[3279]: The file of URL is empty or doesn't exist.
Mar 05 11:28:02 tp5 yt-v2.sh[3279]: The file of URL is empty or doesn't exist.
Mar 05 11:28:12 tp5 yt-v2.sh[3279]: The file of URL is empty or doesn't exist.
```


