#!/bin/bash

# Update
sudo apt-get update -y

# Install Java
sudo apt install openjdk-8-jre-headless -y

sudo apt update -y

# Get Jenkins
wget -q -O - http://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

# Add to List for update
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > \
/etc/apt/sources.list.jenkins.list'

# Get updates for Jenkins prerequesits
sudo apt update -y

# Install Jenkins
sudo apt-get install jenkins -y