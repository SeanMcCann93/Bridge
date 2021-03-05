#!/bin/bash

# Update and install ASW CLI
apt-get update -y && apt install awscli -y

# Set the variables for AWS Configure
aws configure set default.region ${aws_location}
aws configure set aws_access_key_id "${aws_access}"
aws configure set aws_secret_access_key "${aws_sec_access}"

# Install Python
apt install python3 -y
apt install python3-pip -y
apt install python3-venv -y
apt-get install python3-pip -y
apt update -y

# Set up a cache as to hold the Git Config Data
git config --global credential.helper cache
# Git config the users email
git config --global user.email "${git_email}"
# Git config the users Username
git config --global user.name "${git_user}"

# Move to home directory and clone down project
cd /home/ubuntu
git clone https://github.com/${git_user}/${project_name}

# Install Prerequesits
cd /home/ubuntu/${project_name}

# make scripts executable
chmod +x ./scripts/install/*

# Install Terraform
sh scripts/install/terra.sh

# Install Docker
sh scripts/install/docker.sh
sh scripts/install/compose.sh

# Install ansible
sh scripts/install/ansible.sh

# Install Jenkins
sh scripts/install/jenkins.sh

# Continue Prerequesits

echo ".gitignore/n" >> .gitignore

python3 -m venv ${project_name}-venv
echo "/${project_name}-venv/" >> .gitignore
. ${project_name}-venv/bin/activate
pip install flask
pip3 install pytest
pip3 install pytest-cov
pip3 install flask-testing
pip3 install requests
sudo apt update -y

# Enable gn & gp
chmod +x ./scripts/git/*
sudo su
cp scripts/git/gp.sh /bin/gp
cp scripts/git/gp.sh /bin/gp