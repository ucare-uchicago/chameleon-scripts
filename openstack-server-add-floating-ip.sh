#!/bin/bash

# example
# openstack server add floating ip 6ff06f8f-df49-469b-ade8-dbaa2654c57c 129.114.109.236

openstack server add floating ip $1 $2

