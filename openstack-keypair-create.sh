#!/bin/bash

# example
# openstack keypair create --public-key my-key.pub my-key

openstack keypair create --public-key $1 $2
