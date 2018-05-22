#!/bin/bash

# example 
# openstack image create --disk-format qcow2 --container-format bare \
# 	--public --min-disk 5 --min-ram 2048 --file ./centos63.qcow2 centos63-image

openstack image create --disk-format qcow2 --container-format bare \
	--public --min-disk 5 --min-ram 2048 --file ./trusty-sck.qcow2 trusty-java
