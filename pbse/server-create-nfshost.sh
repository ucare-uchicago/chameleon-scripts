#!/bin/bash

openstack server create --flavor pbse.large --image trusty-java --nic net-id=private  \
	  --security-group pbse-secgroup --key-name ucare-chameleon  \
          --user-data user-data-nfshost.sh nfshost

