# TP2

## I - FILES

🌞 Trouver le chemin vers le répertoire personnel de votre utilisateur

```bash
[solar@localhost ~]$ pwd
/home/solar
```

🌞 Trouver le chemin du fichier de logs SSH

```bash
[solar@localhost log]$ pwd
/var/log/
# fichier secure
```

🌞 Trouver le chemin du fichier de configuration du serveur SSH

```bash
[solar@localhost ssh]$ pwd
/etc/ssh
# fichier sshd_config
```

## II - USERS

### Nouveau User

🌞 Créer un nouvel utilisateur

```bash
[solar@localhost home]$ sudo useradd -m -d /home/papier_alu/ marmotte
[solar@localhost ~]$ sudo passwd marmotte
Changing password for user marmotte.
New password: #chocolat
BAD PASSWORD: The password fails the dictionary check - it is based on a dictionary word
Retype new password: #chocolat
passwd: all authentication tokens updated successfully.
```

### Infos enregistrées par le système

🌞 Prouver que cet utilisateur a été créé

```bash
[solar@localhost ~]$ sudo cat /etc/passwd | grep marmotte
marmotte:x:1001:1001::/home/marmotte:/bin/bash
```

🌞 Déterminer le hash du password de l'utilisateur marmotte

```bash
[solar@localhost ~]$ sudo cat /etc/shadow | grep marmotte
marmotte:$6$YM2DYTohO7tO8kr5$LaSq9kAhBj6ImrrwXRqeFYyyr94AQS2hC4a/kGRUSn4HDiCGIah5HkM6WqkZfqaFk8/0eejNyNJg2.nKhK31O1:19744:0:99999:7:::
```

### Connexion sur le nouvel utilisateur

🌞 Tapez une commande pour vous déconnecter : fermer votre session utilisateur

```bash
[solar@localhost home]$ exit
logout
Connection to 10.2.1.2 closed.
```

🌞 Assurez-vous que vous pouvez vous connecter en tant que l'utilisateur marmotte

```bash
PS C:\Users\solar> ssh marmotte@10.2.1.2
marmotte@10.2.1.2s password:
Last login: Mon Jan 22 15:33:16 2024
[marmotte@localhost ~]$ ls /home/solar
ls: cannot open directory '/home/solar': Permission denied
```

## III - Programmes et processus

### Run then kill

🌞 Lancer un processus sleep

```bash
[solar@localhost ~]$ sleep 1000

[solar@localhost ~]$ ps -ef | grep sleep
solar       1830    1812  0 15:41 pts/1    00:00:00 sleep 1000

```

🌞 Terminez le processus sleep depuis le deuxième terminal

```bash
[solar@localhost ~]$ kill 1830
```

### Tâche de fond

🌞 Lancer un nouveau processus sleep, mais en tâche de fond

```bash
[solar@localhost ~]$ sleep 1000 &
[1] 1860
```

🌞 Visualisez la commande en tâche de fond

```bash
[solar@localhost ~]$ ps -ef | grep sleep
solar       1860    1812  0 15:48 pts/1    00:00:00 sleep 1000
```

### Find paths

🌞 Trouver le chemin où est stocké le programme sleep

```bash
[solar@localhost bin]$ ls -al /usr/bin/ | grep sleep
-rwxr-xr-x.  1 root root   36312 Apr 24  2023 sleep
```

🌞 Tant qu'on est à chercher des chemins : trouver les chemins vers tous les fichiers qui s'appellent .bashrc

```bash
[solar@localhost /]$ sudo find -name .bashrc
./etc/skel/.bashrc
./root/.bashrc
./home/solar/.bashrc
./home/papier_alu/.bashrc
```

### La variable PATH

🌞 Vérifier que les commandes sleep, ssh, et ping sont bien des programmes stockés dans l'un des dossiers listés dans votre PATH

```bash
[solar@localhost /]$ echo $PATH
/home/solar/.local/bin:/home/solar/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
[solar@localhost /]$ which sleep
/usr/bin/sleep
[solar@localhost /]$ which ssh
/usr/bin/ssh
[solar@localhost /]$ which ping
/usr/bin/ping
```

## IV - Paquets

🌞 Installer le paquet git

```bash
[solar@localhost /]$ sudo dnf install git -y
```

🌞 Trouvez le chemin où est stocké la commande git

```bash
[solar@localhost /]$ which git
/usr/bin/git
```

🌞 Installer le paquet nginx

```bash
[solar@localhost /]$ sudo dnf install nginx -y
Complete !
```

🌞 Déterminer le chemin vers le dossier de logs de NGINX

```bash
[solar@localhost nginx]$ pwd
/var/log/nginx
```

🌞 Déterminer le chemin vers le dossier qui contient la configuration de NGINX

```bash
[solar@localhost nginx]$ pwd
/etc/nginx
```

🌞 Mais aussi déterminer...

```bash
[solar@localhost ~]$ cd /etc/yum.repos.d
[solar@localhost yum.repos.d]$ grep -nri http
```

## V - Poupée russe

🌞 Récupérer le fichier meow

```bash
[solar@localhost ~]$ sudo dnf install wget -y
[solar@localhost ~]$ wget https://gitlab.com/it4lik/b1-linux-2023/-/raw/master/tp/2/meow?inline=false
[solar@localhost ~]$ mv 'meow?inline=false' meow
```

🌞 Trouver le dossier dawa/

```bash
# ZIP
[solar@localhost ~]$ file meow
meow: Zip archive data, at least v2.0 to extract
[solar@localhost ~]$ mv meow meow.zip
[solar@localhost ~]$ sudo dnf install unzip
[solar@localhost ~]$ sudo unzip meow.zip
Archive:  meow.zip
  inflating: meow
# XZ
[solar@localhost ~]$ file meow
meow: XZ compressed data
[solar@localhost ~]$ mv meow meow.xz
[solar@localhost ~]$ sudo unxz meow.xz
# BZIP2
[solar@localhost ~]$ file meow
meow: bzip2 compressed data, block size = 900k
[solar@localhost ~]$ sudo dnf install bzip2
[solar@localhost ~]$ mv meow meow.bz2
[solar@localhost ~]$ bzip2 -d meow.bz2
# RAR
[solar@localhost ~]$ file meow
meow: RAR archive data, v5
[solar@localhost ~]$ sudo mv meow meow.rar
[solar@localhost ~]$ sudo dnf install https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm
[solar@localhost ~]$ sudo dnf install unrar
[solar@localhost ~]$ sudo unrar e meow.rar
# GZIP
[solar@localhost ~]$ file meow
meow: gzip compressed data, from Unix, original size modulo 2^32 145049600
[solar@localhost ~]$ mv meow meow.gz
[solar@localhost ~]$ sudo gunzip meow.gz
# TAR
[solar@localhost ~]$ file meow
meow: POSIX tar archive (GNU)
[solar@localhost ~]$ mv meow meow.tar
[solar@localhost ~]$ sudo dnf install tar -y
[solar@localhost ~]$ tar -xf meow.tar
```

🌞 Dans le dossier dawa/, déterminer le chemin vers

- le seul fichier de 15Mo

```bash
[solar@localhost dawa]$ find -size 15M
./folder31/19/file39
```

- le seul fichier qui ne contient que des 7

```bash
[solar@localhost dawa]$ grep "777777" -r
folder43/38/file41:77777777777
```

- le seul fichier qui est nommé cookie

```bash
[solar@localhost dawa]$ find -type f -name cookie
./folder14/25/cookie
```

- le seul fichier caché (un fichier caché c'est juste un fichier dont le nom commence par un .)

```bash
[solar@localhost dawa]$ find -type f -name ".*"
./folder32/14/.hidden_file
```

- le seul fichier qui date de 2014

```bash
[solar@localhost dawa]$ find -type f -newermt 2014-01-01 ! -newermt 2015-01-01
./folder36/40/file43
```

- le seul fichier qui a 5 dossiers-parents

```bash
[solar@localhost dawa]$ find -type f -path "*/*/*/*/*/*/*" 
./folder37/45/23/43/54/file43
```

