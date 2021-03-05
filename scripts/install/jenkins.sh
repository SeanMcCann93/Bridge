#!/bin/bash

sudo apt-get update -y

# Install Java
sudo apt install default-jre -y

# Get the Jenkins Key
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -

# Aquire a stable version of Jenkins
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Get updates for Java
sudo apt update  -y

# Install Jenkins
sudo apt install jenkins  -y