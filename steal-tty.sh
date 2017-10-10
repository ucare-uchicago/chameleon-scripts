#!/bin/bash

sudo chown stack:stack `readlink /proc/self/fd/0`
screen -x
