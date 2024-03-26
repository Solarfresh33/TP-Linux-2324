# TP3 : Services
## 1. Service SSH
### I. Analyse du service

🌞 S'assurer que le service sshd est démarré
```
[solar@node1 ~]$ systemctl status
● node1.tp3.b1
    State: running
    Units: 283 loaded (incl. loaded aliases)
     Jobs: 0 queued
   Failed: 0 units
    Since: Tue 2024-01-30 09:51:25 CET; 33min ago
  systemd: 252-13.el9_2
   CGroup: /
           ├─init.scope
           │ └─1 /usr/lib/systemd/systemd --switched-root 
           [...]
           │ ├─sshd.service
           │ │ └─682 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"
```

🌞 Analyser les processus liés au service SSH

```
[solar@node1 ~]$ ps -ef | grep ssh
root         682       1  0 09:51 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root        1298     682  0 09:51 ?        00:00:00 sshd: solar [priv]
solar       1302    1298  0 09:51 ?        00:00:00 sshd: solar@pts/0
solar       1350    1303  0 10:31 pts/0    00:00:00 grep --color=auto ssh
```

🌞 Déterminer le port sur lequel écoute le service SSH

```
[solar@node1 ~]$ sudo ss -alnpt | grep ssh
[sudo] password for solar:
LISTEN 0      128          0.0.0.0:22        0.0.0.0:*    users:(("sshd",pid=682,fd=3))
LISTEN 0      128             [::]:22           [::]:*    users:(("sshd",pid=682,fd=4))
```	

🌞 Consulter les logs du service SSH

```
[solar@node1 ~]$ sudo journalctl -u sshd
Jan 30 09:51:30 node1.tp3.b1 systemd[1]: Starting OpenSSH server daemon...
Jan 30 09:51:30 node1.tp3.b1 sshd[682]: Server listening on 0.0.0.0 port 22.
Jan 30 09:51:30 node1.tp3.b1 sshd[682]: Server listening on :: port 22.
Jan 30 09:51:30 node1.tp3.b1 systemd[1]: Started OpenSSH server daemon.
Jan 30 09:51:52 node1.tp3.b1 sshd[1298]: Accepted password for solar from 10.3.1.1 port 51284 ssh2
Jan 30 09:51:52 node1.tp3.b1 sshd[1298]: pam_unix(sshd:session): session opened for user solar(uid=1000) by (uid=0)
```

### II. Modification du service

🌞 Identifier le fichier de configuration du serveur SSH

```
[solar@node1 ssh]$ sudo cat sshd_config
#       $OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# To modify the system-wide sshd configuration, create a  *.conf  file under
#  /etc/ssh/sshd_config.d/  which will be automatically included below
Include /etc/ssh/sshd_config.d/*.conf

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin prohibit-password
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile      .ssh/authorized_keys

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
#PasswordAuthentication yes
#PermitEmptyPasswords no

# Change to no to disable s/key passwords
#KbdInteractiveAuthentication yes

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no
#KerberosUseKuserok yes

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no
#GSSAPIEnablek5users no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the KbdInteractiveAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via KbdInteractiveAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and KbdInteractiveAuthentication to 'no'.
# WARNING: 'UsePAM no' is not supported in RHEL and may cause several
# problems.
#UsePAM no

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
#X11Forwarding no
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# override default of no subsystems
Subsystem       sftp    /usr/libexec/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#       X11Forwarding no
#       AllowTcpForwarding no
#       PermitTTY no
#       ForceCommand cvs server
```

🌞 Modifier le fichier de conf

```
[solar@node1 ssh]$ sudo cat sshd_config
[sudo] password for solar:
#       $OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# To modify the system-wide sshd configuration, create a  *.conf  file under
#  /etc/ssh/sshd_config.d/  which will be automatically included below
Include /etc/ssh/sshd_config.d/*.conf

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
#Port 30679
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

....
```
