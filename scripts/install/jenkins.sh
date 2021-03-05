#!/bin/bash

# NOTE: This installes for Ubuntu 20.4.1

# Update
sudo apt-get update -y

# Install Java
sudo apt install openjdk-11-jdk -y

sudo apt update -y

# Get Jenkins
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

# Add to List for update
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'

# Get updates for Jenkins prerequesits
sudo apt-get update -y

# Install Jenkins
sudo apt-get install jenkins -y

sudo systemctl start jenkins