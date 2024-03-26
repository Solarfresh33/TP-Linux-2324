# TP 1

## 🌞 Supprimer des fichiers

```bash
[root@localhost boot]$ rm vmlinuz-5.14.0-284.11.1.el9_2.x86_64
```

## 🌞 Mots de passe

```bash
[root@localhost solar]$ nano /etc/shadow

```

## 🌞 Another way ?

```bash
[root@localhost solar]# chmod a-x /bin/bash
```

## 🌞 Effacer le contenu du disque dur

```bash
[root@localhost ~]$ dd if=/dev/zero of=/dev/mapper/rl-root status=progress
```

## 🌞 Reboot automatique


```bash
[solar@localhost ~]$ nano script.sh
# DANS LE FICHIER
#!/bin/bash
reboot
[solar@localhost ~]$ chmod +x script.sh
[solar@localhost ~]$ nano /etc/systemd/system/reboot.service
# DANS LE FICHIER
[Unit]
Description=reboot meow

[Service]
ExecStart=/home/solar/script.sh

[Install]
WantedBy=default.target
[solar@localhost ~]$ sudo systemctl daemon-reload
[solar@localhost ~]$ sudo systemctl enable reboot.service
[solar@localhost ~]$ sudo systemctl start reboot.service
```

## 🌞 Trouvez 4 autres façons de détuire la machine

- Delete bash

```bash
[root@localhost bin]# rm bash
```

- MEOW

```bash
[solar@localhost ~]$ nano uwu.sh
# DANS LE FICHIER
#!/bin/bash
trap '' INT
while true
do
    echo "meow"
done
[solar@localhost ~]$ chmod +x uwu.sh
[solar@localhost ~]$ echo "./uwu.sh" >> /etc/profile
```

- PWD

```bash
[root@localhost solar]# nano /etc/passwd
root:x:0:0:root:/root:/bin/meow 
solar:x:1000:1000:solar:/home/solar:/bin/meow 
```

