#!/bin/bash

# Install any updates
sudo apt update

# Install curl and jq
sudo apt install -y curl jq

# Assign the Variable "version" the latest docker-compose name
version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r '.tag_name')

# Get the latest version
sudo curl -L "https://github.com/docker/compose/releases/download/${version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make the Executable
sudo chmod +x /usr/local/bin/docker-compose

docker-compose --version