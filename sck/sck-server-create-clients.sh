#!/bin/bash

for i in $(seq $1 1 $2)
do
  openstack server create --flavor sck.large --image trusty-sck \
	  --nic net-id=46650a07-a01f-4b10-9ac6-b20f98b9ba00 --security-group 9ae7aad6-7cf7-4e99-a3d9-385c2edfc4f0 \
	  --key-name ucare-chameleon  --user-data sck-user-data-nfsclient.sh node-$i
done

