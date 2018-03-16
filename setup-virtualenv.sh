#!/bin/bash

sudo apt-get update
sudo apt-get install -y virtualenv python-dev
virtualenv --python=/usr/bin/python2.7 venv
source venv/bin/activate
pip install -r enos-requirement.txt

