#!/bin/bash

openstack server create --flavor m1.small --image trusty-java \
	  --nic net-id=35ee448b-459c-4b28-817e-1b3f4c7deda6 --security-group demo-ssh \
	    --key-name ucare-chameleon test

