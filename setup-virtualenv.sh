#!/bin/bash

virtualenv --python=/usr/bin/python2.7 .
source bin/activate
pip install -r enos-requirement.txt

