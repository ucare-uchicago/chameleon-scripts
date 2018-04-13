#!/bin/bash

touch /home/ubuntu/hello-world.txt

apt-get update
apt-get install -y nfs-kernel-server

echo "/home       192.168.0.0/18(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
service nfs-kernel-server restart

