#!/bin/bash

openstack server create --flavor baremetal --image CC-Ubuntu16.04-20180329 \
	  --nic net-id=1a03cf65-8fd6-4fce-94fd-bbaabe68a8e1 --security-group enos-secgroup \
	  --hint reservation=cca05191-f933-4aad-b836-6d818d94031a  --key-name ucare-chameleon $1

