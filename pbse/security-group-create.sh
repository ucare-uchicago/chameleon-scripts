#!/bin/bash


openstack security group create pbse-secgroup
openstack security group rule create pbse-secgroup --protocol icmp --dst-port 1:65535 --remote-ip 0.0.0.0/0
openstack security group rule create pbse-secgroup --protocol tcp --dst-port 1:65535 --remote-ip 0.0.0.0/0
openstack security group rule create pbse-secgroup --protocol udp --dst-port 1:65535 --remote-ip 0.0.0.0/0
