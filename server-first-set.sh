#!/bin/bash

read -p "input add username:" username
read -p "input password of ${username}:" userpass
read -p "input root password(press enter to skip):" rootpass
read -p "input ssh port:" port
echo -e "\033[36muser ${username}'s password is:${userpass}\033[0m"
echo -e "\033[36myour root password:${rootpass}\033[0m"
echo -e "\033[36myour ssh port is:${port}\033[0m"
read -p "is continue?[Y/n]" isok
if [ "$isok" == 'n' ]; then
        echo -e "\033[31mended\033[0m"
        exit 1
fi
yum -y update
yum install -y screen zip unzip sendmail lrzsz

if cat /etc/passwd | grep ^${username}; then
        echo "user ${username} already exist."
else
        echo "add user:${username}"
        useradd ${username}
fi
echo ${username}:${userpass} | chpasswd
if [ "${rootpass}" != '' ]; then
        echo "root:${rootpass}" | chpasswd
else
        echo -e "\033[31mDo not set root pass.\033[0m"
fi
sed -in "s/[# ]*Port [0-9]\+/Port ${port}/" /etc/ssh/ssh_config
sed -in "s/[# ]*Port [0-9]\+/Port ${port}/" /etc/ssh/sshd_config
sed -in 's/[# ]*PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
if [ -s /usr/sbin/firewalld ]; then
        systemctl stop firewalld
        systemctl disable firewalld
        systemctl mask firewalld
        yum install -y iptables-services iptables-devel
        systemctl enable iptables.service
        chkconfig iptables on
fi
if iptables -L -n | grep ${port}; then
        echo "port ${port} is already opened."
else
        echo "add iptables rule for port:${port}"
        iptables -A INPUT -p tcp --dport ${port} -j ACCEPT
fi
service iptables save
echo "close selinux."
setenforce 0
sed -n '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
service sshd restart
echo "your ssh port is:${port}"
echo -e "\033[31mPlease remove old port rule from iptables by yourself.The command is:\n\033[36miptables -D -p tcp --dport {yourport} -j ACCEPT\033[0m"
