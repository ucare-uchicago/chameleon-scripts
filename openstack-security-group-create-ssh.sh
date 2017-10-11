#!/bin/bash

openstack security group create demo-ssh
openstack security group rule create --ingress --protocol icmp demo-ssh
openstack security group rule create --ingress --dst-port 22 demo-ssh
openstack security group rule create --ingress --dst-port 80 demo-ssh

