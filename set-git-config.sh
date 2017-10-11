#!/bin/bash

echo "Please enter your git name: "
read -r GIT_NAME_INPUT
git config --global user.name "$GIT_NAME_INPUT"

echo "Please enter your git email: "
read -r GIT_EMAIL_INPUT
git config --global user.email "$GIT_EMAIL_INPUT"

