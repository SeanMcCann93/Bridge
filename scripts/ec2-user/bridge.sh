#!/bin/bash
sudo su ubuntu
sudo apt-get update -y
sudo apt install awscli -y
sudo apt install python3 -y
sudo apt install python3-pip -y
sudo apt install python3-venv -y
sudo apt-get install python3-pip -y
apt update -y
git config --global credential.helper cache
git config --global user.email "${git_email}"
git config --global user.name "${git_user}"
cd /home/ubuntu
git clone https://github.com/${git_user}/${project_name}
cd ./${project_name}
chmod +x ./scripts/git/*
chmod +x ./scripts/install/*
sh ./scripts/install/terra.sh
sh ./scripts/install/docker.sh
sh ./scripts/install/compose.sh
sh ./scripts/install/ansible.sh
sh ./scripts/install/jenkins.sh
echo ".gitignore\n" >> .gitignore
python3 -m venv ${project_name}-venv
echo "/${project_name}-venv/" >> .gitignore
. ${project_name}-venv/bin/activate
pip install flask
pip3 install pytest
pip3 install pytest-cov
pip3 install flask-testing
pip3 install requests
sudo apt update -y
sudo su
cp scripts/git/gp.sh /bin/gp
cp scripts/git/gp.sh /bin/gp