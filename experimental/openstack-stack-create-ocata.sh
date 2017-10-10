#!/bin/bash

# example
# openstack stack create mystack -f some-template.yaml -P "Key1=Val1;Key2=Val2"
# openstack stack create -e environment.env -t template.hot stack-name

# openstack stack create --parameter "compute_node_count=2;key_name=my-ssh-key;reservation_id=5d3bfb2a-37f6-40c9-8080-2685dc3d1b69" -t ocata.hot dmck-hadoop
openstack stack create -e ocata.env -t ocata.hot dmck-hadoop

