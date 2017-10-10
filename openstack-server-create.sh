#!/bin/bash

openstack server create --flavor m1.small --image trusty-java \
	  --network public --security-group ssh \
	    --key-name ucare-chameleon server-name

