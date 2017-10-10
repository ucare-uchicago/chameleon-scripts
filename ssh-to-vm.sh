#!/bin/bash

# example
# sudo ip netns exec qrouter-33818dff-8e46-45d2-8a5e-22dd0315127c ssh cirros@192.168.1.3

sudo ip netns exec $1 ssh $2
