#!/bin/bash

# Aquire all data needed for terraform and new instance script
echo "AWS Configure"
read -p 'AWS Access Key : ' temp_access
# Hide the input of password
stty -echo
read -p "AWS Secret Access Key: " temp_sec_access
stty echo
echo ""
read -p 'AWS Region? ' temp_location
echo ""
echo "GIT Set-up"
read -p "Git User Name: " git_user
read -p "Git email : " git_email
# read -p "Git Project : " git_pro
git_pro = "Bridge"

# Update and install ASW CLI
sudo apt-get update -y && sudo apt install awscli -y

# NOTE: you need to set up an IAM account and not use the Root User account!
# Set the variables for AWS Configure
aws configure set default.region ${temp_location}
aws configure set aws_access_key_id "${temp_access}"
aws configure set aws_secret_access_key "${temp_sec_access}"
aws configure set default.output "text"

# make scripts executable
chmod +x ./scripts/install/*
chmod +x ./scripts/key/*
chmod +x ./scripts/ec2-user/bridge.sh

# Install Terraform
sh scripts/install/terra.sh

# Create SHH Key for Access
sh scripts/key/bridge-keygen.sh

cd Terraform/Bridge/ && terraform init

echo ""
echo "      :::::::::  :::           :::     ::::    :::"
echo "     :+:    :+: :+:         :+: :+:   :+:+:   :+:"
echo "    +:+    +:+ +:+        +:+   +:+  :+:+:+  +:+"
echo "   +#++:++#+  +#+       +#++:++#++: +#+ +:+ +#+"
echo "  +#+        +#+       +#+     +#+ +#+  +#+#+#"  
echo " #+#        #+#       #+#     #+# #+#   #+#+#"
echo "###        ######### ###     ### ###    ####"
echo ""

terraform plan -var aws_ac="${temp_access}" -var aws_sec_ac="${temp_sec_access}" -var git_pro="${git_pro}" -var git_mail="${git_email}" -var git_user="${git_user}" -var aws_location="${temp_location}"

echo ""
echo "      :::::::::  :::    ::: ::::::::: :::       :::::::::"
echo "     :+:    :+: :+:    :+:    :+:    :+:       :+:    :+:"
echo "    +:+    +:+ +:+    +:+    +:+    +:+       +:+    +:+"
echo "   +#++:++#+  +#+    +:+    +#+    +#+       +#+    +:+"
echo "  +#+    +#+ +#+    +#+    +#+    +#+       +#+    +#+"
echo " #+#    #+# #+#    #+#    #+#    #+#       #+#    #+#"
echo "#########   ########  ######### ######### #########"
echo ""

terraform apply -var aws_ac="${temp_access}" -var aws_sec_ac="${temp_sec_access}" -var git_pro="${git_pro}" -var git_mail="${git_email}" -var git_user="${git_user}" -var aws_location="${temp_location}" -auto-approve