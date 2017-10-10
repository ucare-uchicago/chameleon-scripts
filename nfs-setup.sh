#!/bin/bash

apt-get update
apt-get install nfs-kernel-server

echo "/home       10.1.1.0/24(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
service nfs-kernel-server restart
