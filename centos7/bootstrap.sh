#!/bin/bash

# Update hosts file
echo "[TASK 1] Update packages"
yum update -y && yum upgrade -y

# Update hosts file
echo "[TASK 2] nstall packages"
yum install -y vim wget git net-tools traceroute telnet

# Install java-1.8
yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel

# install ntp
yum -y install ntp
systemctl enable ntpd
systemctl start ntpd

# Disable SELinux
echo "[TASK 3] Disable SELinux"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

# Stop and disable firewalld
echo "[TASK 4] Stop and Disable firewalld"
systemctl disable firewalld >/dev/null 2>&1
systemctl stop firewalld


# Disable swap
echo "[TASK 5] Disable and turn off SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

# Enable ssh password authentication
echo "[TASK 6] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd

echo "[TASK 7] Set root password"
echo "root" | passwd --stdin root >/dev/null 2>&1

echo "[TASK 8] Create ambari user"
useradd ambari -m  >/dev/null 2>&1
echo "ambari:ambari" | chpasswd  >/dev/null 2>&1
usermod -aG wheel ambari  >/dev/null 2>&1


# echo "[TASK 11] Reboot"
# reboot


# !!! NOT NEEDED. HOSTMANAGER WILL ADD THIS AUTOMATICALLY
# Update hosts file 
# echo "[TASK 3] Update /etc/hosts file"
# cat >>/etc/hosts<<EOF
# 192.168.0.10 master.cloudera master
# 192.168.0.11 node1.cloudera node1
# 192.168.0.12 node2.cloudera node2
# 192.168.0.13 node3.cloudera node3
# EOF


# Download Ambari Repository
# wget -nv http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.2.0.0/ambari.repo -O /etc/yum.repos.d/ambari.repo
wget -nv http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.7.4.0/ambari.repo -O /etc/yum.repos.d/ambari.repo