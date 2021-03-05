# Needed as a prerequisite
sudo apt install python3 python3-pip

# Make/Confirm directory exists 
mkdir -p ~/.local/bin

# send data to this file
echo 'PATH=$PATH:~/.local/bin' >> ~/.bashrc

source ~/.bashrc

sudo apt install ansible

ansible --version