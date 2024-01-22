# TP1 : Casser avant de construire

## II. Casser
### 2. Fichiers


🌞 Supprimer des fichiers

```
[root@localhost home]# cd ..
[root@localhost /]# ls
afs  bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
[root@localhost /]# cd boot
 ls
config-5.14.0-284.11.1.el9_2.x86_64                      loader
efi                                                      symvers-5.14.0-284.11.1.el9_2.x86_64.gz
grub2                                                    System.map-5.14.0-284.11.1.el9_2.x86_64
initramfs-0-rescue-97bbb26c130240309033736e101bc2e9.img  vmlinuz-0-rescue-97bbb26c130240309033736e101bc2e9
initramfs-5.14.0-284.11.1.el9_2.x86_64.img               vmlinuz-5.14.0-284.11.1.el9_2.x86_64
initramfs-5.14.0-284.11.1.el9_2.x86_64kdump.img

[root@localhost boot]# sudo rm initramfs-0-rescue-97bbb26c130240309033736e101bc2e9.img
[root@localhost boot]# sudo rm initramfs-5.14.0-284.11.1.el9_2.x86_64.img
[root@localhost boot]# sudo rm initramfs-5.14.0-284.11.1.el9_2.x86_64kdump.img
```

## 3. Utilisateurs

🌞 Mots de passe

```
[root@localhost ~]$ users_with_password=$(sudo awk -F: '$2 ~ /^[^!*]/ {print $1}' /etc/shadow)

for user in $users_with_password; do
    sudo passwd $user
done
[sudo] password for solar:
Changing password for user solar.
New password:
BAD PASSWORD: The password is shorter than 8 characters
Retype new password:
Sorry, passwords do not match.
New password:
Retype new password:
Sorry, passwords do not match.
New password:
BAD PASSWORD: The password is shorter than 8 characters
Retype new password:
passwd: all authentication tokens updated successfully.
Changing password for user solar.
New password:
BAD PASSWORD: The password is shorter than 8 characters
Retype new password:
passwd: all authentication tokens updated successfully.
```

## 4. Disques

🌞 Effacer le contenu du disque dur

```
[root@localhost dev]# sudo dd if=/dev/zero of=/dev/sda bs=4M status=progress
8317304832 bytes (8.3 GB, 7.7 GiB) copied, 14 s, 594 MB/s
dd: error writing '/dev/sda': No space left on device
2049+0 records in
2048+0 records out
8589934592 bytes (8.6 GB, 8.0 GiB) copied, 14.4302 s, 595 MB/s
Segmentation fault (core dumped)
```

## 5. Malware

🌞 Reboot automatique

```powershell
[solar@localhost ~]$ nano ~/.bashrc

# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
        for rc in ~/.bashrc.d/*; do
                if [ -f "$rc" ]; then
                        . "$rc"
                fi
        done
fi

unset rc

sudo reboot
```

## 6. You own way

🌞 Trouvez 4 autres façons de détuire la machine

1) La fork bomb

    :(){ :|:& };: 

2) En autorisant un seul processus maximum

> sudo nano /etc/security/limits.conf 

```powershell
#<domain>       <type>  <item>      <value>
#

*               soft    core        0
*               hard    nproc       1

```

> sudo systemctl restart NetworkManager

Quand on essaie de rallumer la vm et de se connecter, uen erreur bash apparaît. Il peut pas y avoir plus de processus en cours.

3) /

4) /
