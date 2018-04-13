#!/bin/bash


echo "Starting NSF mounting..." >> /tmp/bootstrap.log

apt-get update
apt-get install -y nfs-common

echo "nfs-common installed..." >> /tmp/bootstrap.log

echo "192.168.0.11:/home    /home    nfs" >> /etc/fstab
mount -a

echo "NSF mounting done!" >> /tmp/bootstrap.log

