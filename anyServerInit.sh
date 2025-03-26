#!/bin/bash

# 1.安裝OS

# 2.設定密碼及網路
# vi /etc/netplan/00-installer-config.yaml
# vi /etc/hostname
# vi /etc/hosts
# rm -f /etc/nginx/sites-enabled/*
# rm -f /etc/nginx/sites-available/*

apt update
apt install vim parted xfsprogs git gpg curl

# 3.DISK 調整
# parted -s /dev/sdb -- mklabel gpt mkpart primary 2048s -0
# vgcreate sev /dev/sdb1
# lvcreate -l 100%FREE -n data srv
# mkfs.xfs  /dev/srv/data

groupadd -g 11 wheel
useradd -m -d /home/adm -s /bin/bash -g wheel adm
echo "PS1='\h U22 \t [\w] -\u- '" > /home/adm/.profile
echo "DIR 04;32 # directory" > /home/adm/.dircolors
mkdir /home/adm/.ssh
cat << END > /home/adm/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDOKDjTeWT+wnXBWOicdyZ605N6qtV6TN1wIO04xxKXZyobC84FyjsbFoStFxEFWqZR58fwOMW+jumZmPC3kTYg+C+yP9smKzRSbXhDGZL1bumDZCGgdLmXH00dVl+82efm3ph7F0BcVCzF7L8kSnskcehP9Tdbaim6ufOVukTC7kK8CqjLYYBKvdIHwlAq6R3wRotrmNwk/ivoYokyn+iRvNOJPTc8z6Kt7ILEJalOzFOgugromrOrS6xYDSAEcStb6mvsN3YHwx2zcnnzsSbczYJWYobUBk0+KwJVXMeIA2U0FM9pnl/vHvCkl4S1M+gnTYpTy/fL+puLhXwD08a8czBcyEhuoVX7UsF01+uNfXjm3R9KjHX3zGB/rPEKLU1mIuNmzhybCspbe6IbrLLDUax1PEAcQkpYjuKaK4EUZzQko/fFFhuNI9zn5PO6jVM4+eag0gwr5VhQr69yHohEEdNKFUK+aNsIZ02bgukXpgw1ajSPEjLaczZnUIoCoYs= felix

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDlGG2cvctkNLZYpS7R30D/a1k31qMg1EAGVCJRwGeILU7fZO1U+uZVNvErGaL2oifuJ0/JM63rhjYemm7q5tFu67sH9ziMISFKfESIQ6+xLddTKVicnHb8GjxWo6LFZb2lmJIxPAvNO++TMdRmDLoRHfdF7C1zunQ7vgINPsdObto5TRYCNhEV0g/kMLmiPzk/RyrKQxyomid+eWEMP5uCmgw9siDzkbsLsznXqOSu58dAtXns62iSGg9iMd3YVc0Lh3i/uUkrrnj/yntaLWeAX5+fVWNLRDbBqiyW6W+Dth/AqiCs04KE5qXAr63EkeuFEB7rsKokKDyV5xXy72QIdtsv2wBDPqBxW0/XcwahDdZ5P0p0jYL9lj+J/wqQ1WJct9GzrBlvL7xIuCtn87+9H0cWDwLU5nyZDN7CUdK46M2svL07UrRkmOWALTB12EFJctrzww6skjy2Vbt0Px/0ed2tOmPbIhPZO+09hpRwYRDcLbRywnK9HgK++0M0A3E= felix
END

chmod 600 /home/adm/.ssh/authorized_keys
chown -R adm:wheel /home/adm
# echo 'password' | mkpasswd -m sha-512 -s
sed -i 's|^adm:!:|adm:$6$DnigYKrUEYFXf$LHQbtdIZw/hFRLTVRJpFsqI/M1GF8NioQqzEGAhpKX1g9w7SIAsdQJ6LUAC1Ab4MtwKKTZWL3w9Azl37KVDmd1:|' /etc/shadow
sed -i 's|^root:|root:$6$ey9kYZTxtH42EZuc$R7ePwW6CCuaG13Uub9mU84VK8kgY/TaiFZEPIsx3SGwoza4dmhf35Sp9IkUQ3huY6p.uePjbafjfyZNoPIQ9S/|' /etc/shadow


cat << END >> /root/.profile
if [ -z "$WINDOW" ]; then
PS1='\[\e[1;33m\]\h \[\e[0;36m\]U22\[\e[0;37m\] \A [\[\e[m\]\[\e[0;32m\]\w\[\e[0;37m\]] -\u\[\e[m\]- '
  #stty erase '^?'
else
PS1='\[\e[1;33m\]\h \[\e[0;36m\]U22\[\e[0;37m\] \A [\[\e[m\]\[\e[0;32m\]\w\[\e[0;37m\]] -\u\[\e[m\]- [$WINDOW] '
  #stty erase '^H'
fi
END

cat << END >> /etc/profile
PS1='\h [\w] -\u- '
export TMOUT=1800
export TERM=xterm-256color

alias SYNC='sync;sync;sync;sync;sync'
alias cpnull='cp /dev/null'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls --color=auto'
alias more='less'
alias mv='/bin/mv -i'
alias unlo='export TMOUT=0'
END

grep -v "^PermitRootLogin yes" /etc/ssh/sshd_config > /tmp/sshd
echo "AllowUsers adm" >> /tmp/sshd
mv -f /tmp/sshd /etc/ssh/sshd_config

ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime
