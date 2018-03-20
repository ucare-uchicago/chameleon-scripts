#!/usr/bin/env bash

IF=eno1
# This is the list of the vip of eno1
ips=$(ip addr show dev $IF|grep "inet .*/32" | awk '{print $2}')
if [[ ! -z "$ips" ]]
then
  # vip detected
  echo $ips
  docker exec -ti openvswitch_vswitchd ovs-vsctl add-port br-ex $IF && ip addr flush $IF && dhclient -nw br-ex
  for ip in $ips
  do
    ip addr add $ip dev br-ex
  done
else
  echo "nothing to do"
fi
