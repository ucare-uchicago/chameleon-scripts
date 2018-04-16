#!/bin/bash

for i in $(seq $1 1 $2)
do
  openstack server create --flavor pbse.large --image trusty-java --nic net-id=private  \
          --security-group pbse-secgroup --key-name ucare-chameleon  \
          --user-data user-data-nfsclient.sh node-$i
done

