#!/bin/bash

virtualenv --python=/usr/bin/python2.7 .
source bin/activate
pip install enos
pip install git+https://github.com/openstack/python-blazarclient

