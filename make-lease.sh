#!/bin/bash

# example:
# blazar lease-create --physical-reservation min=1,max=1 --start-date "2020-06-08 12:00" --end-date "2020-06-09 12:00" lease-1

blazar lease-create --physical-reservation min=1,max=$4 --start-date "$2" --end-date "$3" $1
