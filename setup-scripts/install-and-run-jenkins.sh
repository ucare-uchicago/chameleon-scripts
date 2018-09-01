#!/usr/bin/env bash

sudo docker pull jenkins/jenkins:lts

tmux new-session -d -s "jenkins" \
    "sudo docker run -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts"

