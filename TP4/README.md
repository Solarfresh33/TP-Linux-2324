# TP4

## I. Partionnement du stockage

🌞 Partitionner le disque à l'aide de LVM

```bash
[solar@storage ~]$ lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda           8:0    0    8G  0 disk
├─sda1        8:1    0    1G  0 part /boot
└─sda2        8:2    0    7G  0 part
  ├─rl-root 253:0    0  6.2G  0 lvm  /
  └─rl-swap 253:1    0  820M  0 lvm  [SWAP]
sdb           8:16   0    2G  0 disk
sdc           8:32   0    2G  0 disk
sr0          11:0    1 1024M  0 rom
[solar@storage ~]$ sudo pvcreate /dev/sdb
[sudo] password for solar:
  Physical volume "/dev/sdb" successfully created.
[solar@storage ~]$ sudo pvcreate /dev/sdc
  Physical volume "/dev/sdc" successfully created.
[solar@storage ~]$ sudo pvs
  Devices file sys_wwid t10.ATA_VBOX_HARDDISK_VB5c3eb0e2-01170581 PVID eGYQe2yRlzY2Gze2IrvbLiQJIXftIWbE last seen on /dev/sda2 not found.
  PV         VG Fmt  Attr PSize PFree
  /dev/sdb      lvm2 ---  2.00g 2.00g
  /dev/sdc      lvm2 ---  2.00g 2.00g
[solar@storage ~]$ sudo vgcreate storage /dev/sdb
  Volume group "storage" successfully created
[solar@storage ~]$ sudo vgextend storage /dev/sdc
  Volume group "storage" successfully extended
[solar@storage ~]$ sudo vgs
  Devices file sys_wwid t10.ATA_VBOX_HARDDISK_VB5c3eb0e2-01170581 PVID eGYQe2yRlzY2Gze2IrvbLiQJIXftIWbE last seen on /dev/sda2 not found.
  VG      #PV #LV #SN Attr   VSize VFree
  storage   2   0   0 wz--n- 3.99g 3.99g
[solar@storage ~]$ sudo lvcreate -l 100%FREE storage -n firstlv
  Logical volume "firstlv" created.
[solar@storage ~]$ lsblk
NAME              MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                 8:0    0    8G  0 disk
├─sda1              8:1    0    1G  0 part /boot
└─sda2              8:2    0    7G  0 part
  ├─rl-root       253:0    0  6.2G  0 lvm  /
  └─rl-swap       253:1    0  820M  0 lvm  [SWAP]
sdb                 8:16   0    2G  0 disk
└─storage-firstlv 253:2    0    4G  0 lvm
sdc                 8:32   0    2G  0 disk
└─storage-firstlv 253:2    0    4G  0 lvm
sr0                11:0    1 1024M  0 rom
```

🌞 Formater la partition

```bash
[solar@storage ~]$ sudo mkfs -t ext4 /dev/storage/firstlv
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 1046528 4k blocks and 261632 inodes
Filesystem UUID: 8d14930f-5cfc-4220-8417-4c20d97f0fa9
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done
```

🌞 Monter la partition

- Montage partition

 ```bash
 [solar@storage ~]$ sudo mkdir /storage
 [solar@storage ~]$ sudo mount /dev/storage/firstlv /storage/
 [solar@storage storage]$ df -h | grep storage
Filesystem                   Size  Used Avail Use% Mounted on
/dev/mapper/storage-firstlv  3.9G   24K  3.7G   1% /storage
 ```

- Montage Auto

```bash
[solar@storage ~]$ sudo nano /etc/fstab
[solar@storage ~]$ sudo cat /etc/fstab | grep storage
/dev/storage/firstlv    /storage                ext4    defaults        0 0
[solar@storage ~]$ sudo umount /storage 
[solar@storage ~]$ sudo mount -av | grep storage
/storage                 : successfully mounted
[solar@storage ~]$ df -h | grep storage
/dev/mapper/storage-firstlv  3.9G   24K  3.7G   1% /storage
```

## II. Serveur de partage de fichiers

🌞 Donnez les commandes réalisées sur le serveur NFS storage.tp4.linux

```bash
[solar@storage ~]$ sudo dnf install nfs-utils -y
[solar@storage ~]$ sudo mkdir /storage/site_web_1/ -p
[solar@storage ~]$ sudo mkdir /storage/site_web_2/ -p
[solar@storage ~]$ sudo cat /etc/exports
/storage/site_web_1     10.4.1.3(rw,sync,no_root_squash,no_subtree_check)
/storage/site_web_2     10.4.1.3(rw,sync,no_root_squash,no_subtree_check)
[solar@storage ~]$ sudo systemctl enable nfs-server
Created symlink /etc/systemd/system/multi-user.target.wants/nfs-server.service → /usr/lib/systemd/system/nfs-server.service.
[solar@storage ~]$ sudo systemctl start nfs-server
[solar@storage ~]$ sudo systemctl status nfs-server
● nfs-server.service - NFS server and services
     Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; enabled; p>
    Drop-In: /run/systemd/generator/nfs-server.service.d
             └─order-with-mounts.conf
     Active: active (exited) since Mon 2024-02-19 16:22:17 CET; 5s ago
[solar@storage ~]$ sudo firewall-cmd --permanent --add-service=nfs
success
[solar@storage ~]$ sudo firewall-cmd --permanent --add-service=mountd
success
[solar@storage ~]$ sudo firewall-cmd --permanent --add-service=rpc-bind
success
[solar@storage ~]$ sudo firewall-cmd --reload
success
```

🌞 Donnez les commandes réalisées sur le client NFS web.tp4.linux

```bash
[solar@storage ~]$ sudo dnf install nfs-utils -y
[solar@web ~]$ sudo mkdir -p /var/www/site_web_1/
[solar@web ~]$ sudo mkdir -p /var/www/site_web_2/
[solar@web ~]$ sudo mount 10.4.1.2:/storage/site_web_1 /var/www/site_web_1/
[solar@web ~]$ sudo mount 10.4.1.2:/storage/site_web_2 /var/www/site_web_2/
[solar@web ~]$ df -h | grep storage
10.4.1.2:/storage/site_web_1  3.9G     0  3.7G   0% /var/www/site_web_1
10.4.1.2:/storage/site_web_2  3.9G     0  3.7G   0% /var/www/site_web_2
[solar@web ~]$ sudo cat /etc/fstab | grep storage
10.4.1.2:/storage/site_web_1    /var/www/site_web_1   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
10.4.1.2:/storage/site_web_2    /var/www/site_web_2   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
```

## III. Serveur web

🌞 Installez NGINX

```bash
[solar@web ~]$ sudo dnf install nginx -y
```

🌞 Analysez le service NGINX

```bash
[solar@web ~]$ ps -ef| grep nginx
root        4392       1  0 12:49 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       4393    4392  0 12:49 ?        00:00:00 nginx: worker process
solar       4399    4173  0 12:49 pts/0    00:00:00 grep --color=auto nginx
[solar@web ~]$ ss -salputen | grep nginx
tcp   LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    ino:28410 sk:5 cgroup:/system.slice/nginx.service <->
tcp   LISTEN 0      511             [::]:80           [::]:*    ino:28411 sk:8 cgroup:/system.slice/nginx.service v6only:1 <->
[solar@web ~]$ sudo cat /etc/nginx/nginx.conf | grep root
        root         /usr/share/nginx/html;
[solar@web ~]$ sudo ls -al /usr/share/nginx/html
total 12
drwxr-xr-x. 3 root root  143 Feb 20 12:47 .
drwxr-xr-x. 4 root root   33 Feb 20 12:47 ..
-rw-r--r--. 1 root root 3332 Oct 16 19:58 404.html
-rw-r--r--. 1 root root 3404 Oct 16 19:58 50x.html
drwxr-xr-x. 2 root root   27 Feb 20 12:47 icons
lrwxrwxrwx. 1 root root   25 Oct 16 20:00 index.html -> ../../testpage/index.html
-rw-r--r--. 1 root root  368 Oct 16 19:58 nginx-logo.png
lrwxrwxrwx. 1 root root   14 Oct 16 20:00 poweredby.png -> nginx-logo.png
lrwxrwxrwx. 1 root root   37 Oct 16 20:00 system_noindex_logo.png -> ../../pixmaps/system-noindex-logo.png
```

🌞 Configurez le firewall pour autoriser le trafic vers le service NGINX

```bash
[solar@web ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[solar@web ~]$ sudo firewall-cmd --reload
success
```

🌞 Accéder au site web

```bash
[solar@web ~]$ curl http://10.4.1.3 | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
```

🌞 Vérifier les logs d'accès

```bash
[solar@web ~]$ sudo cat /var/log/nginx/access.log | tail -n 3
10.4.1.3 - - [20/Feb/2024:12:57:22 +0100] "GET / HTTP/1.1" 200 7620 "-" "curl/7.76.1" "-"
10.4.1.3 - - [20/Feb/2024:12:57:26 +0100] "GET / HTTP/1.1" 200 7620 "-" "curl/7.76.1" "-"
10.4.1.3 - - [20/Feb/2024:12:57:37 +0100] "GET / HTTP/1.1" 200 7620 "-" "curl/7.76.1" "-"
```

🌞 Changer le port d'écoute

```bash
[solar@web ~]$ sudo cat /etc/nginx/nginx.conf | grep 8080
        listen       8080;
        listen       [::]:8080;
[solar@web ~]$ sudo systemctl restart nginx
[solar@web ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; preset: disabled)
     Active: active (running) since Tue 2024-02-20 13:01:38 CET; 5min ago
[solar@web ~]$ ss -salputen | grep nginx
tcp   LISTEN 0      511          0.0.0.0:8080      0.0.0.0:*    ino:30126 sk:53 cgroup:/system.slice/nginx.service <->
tcp   LISTEN 0      511             [::]:8080         [::]:*    ino:30127 sk:54 cgroup:/system.slice/nginx.service v6only:1 <->
[solar@web ~]$ sudo firewall-cmd --remove-port=80/tcp --permanent
success
[solar@web ~]$ sudo firewall-cmd --add-port=8080/tcp --permanent
success
[solar@web ~]$ sudo firewall-cmd --reload
success
[solar@web ~]$ curl http://10.4.1.3:8080 | head -n 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
```

🌞 Changer l'utilisateur qui lance le service

```bash
[solar@web ~]$ sudo useradd web
[solar@web ~]$ sudo passwd web
Changing password for user web.
New password:
BAD PASSWORD: The password is shorter than 8 characters
Retype new password:
passwd: all authentication tokens updated successfully.
[solar@web ~]$ sudo cat /etc/nginx/nginx.conf | grep user
user web;
[solar@web ~]$ sudo systemctl restart nginx
[solar@web ~]$ ps -ef | grep nginx
root        4634       1  0 13:58 ?        00:00:00 nginx: master process /usr/sbin/nginx
web         4635    4634  0 13:58 ?        00:00:00 nginx: worker process
```

🌞 Changer l'emplacement de la racine Web

```bash
[solar@web ~]$ sudo cat /var/www/site_web_1/index.html
<h1>MEOW</h1>
[solar@web ~]$ sudo cat /etc/nginx/nginx.conf | grep root
        root         /var/www/site_web_1;
[solar@web ~]$ sudo systemctl restart nginx
[solar@web ~]$ sudo curl 10.4.1.3:8080
<h1>MEOW</h1>
```

🌞 Repérez dans le fichier de conf

```bash
[solar@web ~]$ sudo cat /etc/nginx/nginx.conf | grep conf.d
    # Load modular configuration files from the /etc/nginx/conf.d directory.
    include /etc/nginx/conf.d/*.conf;
```

🌞 Créez le fichier de configuration pour le premier site

```bash
[solar@web ~]$ sudo cat /etc/nginx/conf.d/site_web_1.conf
server {
    listen       8080;
    server_name  10.4.1.3;
    root         /var/www/site_web_1;
        index        index.html;

        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
          location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
          location = /50x.html {
        }
    }
```

🌞 Créez le fichier de configuration pour le deuxième site

```bash
[solar@web ~]$ sudo firewall-cmd --add-port=8888/tcp --permanent
success
[solar@web ~]$ sudo firewall-cmd --reload
success
[solar@web ~]$ sudo cat /var/www/site_web_2/index.html
<p>aled oskour</p>
[solar@web ~]$ sudo cat /etc/nginx/conf.d/site_web_2.conf
server {
    listen       8888;
    server_name  10.4.1.3;
    root         /var/www/site_web_2;
        index        index.html;

        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
          location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
          location = /50x.html {
        }
    }
[solar@web ~]$ sudo systemctl restart nginx
```

🌞 Prouvez que les deux sites sont disponibles

```bash
[solar@web ~]$ curl 10.4.1.3:8080
<h1>MEOW</h1>
[solar@web ~]$ curl 10.4.1.3:8888
<p>aled oskour</p>
```

