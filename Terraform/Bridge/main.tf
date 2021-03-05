# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@ Prerequesits ~ START @@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# Run ~/-Crosswave-Technology/Step1.sh

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@ Prerequesits ~ END @@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

provider "aws" {
  # version                 = "~> 2.8"
  region                  = var.aws_location
  shared_credentials_file = "./../../../.aws/credentials"
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@ Key Pair for machine Access @@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

resource "aws_key_pair" "key_pair" {
  key_name   = "Bridge"
  public_key = file("~/.ssh/Bridge.pub")
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@ Create Virtual Priv Network @@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

module "vpc" {
  source  = "./VPC"
  v4_cidr = "126.157.0.0/16"
  hostname = true

  # @@@ TAGS @@@
  name_tag = "Bridge-Cloud"
  network_tag = "Bridge"
}

module "igw" {
  source = "./IGW"
  vpc_id = module.vpc.id

  # @@@ TAGS @@@
  name_tag    = "Bridge_Network_Gate"
  network_tag = "Bridge"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "subnet_main" {
  source  = "./SUBNET"
  availability_zone = data.aws_availability_zones.available.names[0]
  v4_cidr = "126.157.10.0/24"
  pub_ip  = true
  vpc_id  = module.vpc.id

  # @@@ TAGS @@@
  name_tag    = "Bridge_Subnet"
  network_tag = "Bridge"
}

module "subnet_required" {
  source  = "./SUBNET"
  availability_zone = data.aws_availability_zones.available.names[1]
  v4_cidr = "126.157.20.0/24"
  pub_ip  = true
  vpc_id  = module.vpc.id

  # @@@ TAGS @@@
  name_tag    = "Closed_Bridge_Subnet"
  network_tag = "Bridge"
}

module "public_routes" {
  source  = "./ROUTES"
  vpc_id  = module.vpc.id
  v4_cidr = "0.0.0.0/0"
  igw_id  = module.igw.id

  # @@@ TAGS @@@
  name_tag    = "Bridge-Routes"
  network_tag = "Bridge"
}

module "public_routes_association" {
  source    = "./ROUTES/ASSOCIATION"
  table_id  = module.public_routes.id
  subnet_id = module.subnet_main.id
}

# iam user

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@ Create Security Group @@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

module "sg" {
  source         = "./SG"
  sg_description = "This Security Group is created to allow various port access to an instance."
  vpc_id         = module.vpc.id
  port_desc      = {
    22 = "SSH-Port"
    5000 = "Flask-Front"
    5001 = "Flask-BackEnd"
    80 = "Open-Internet-Access"
    }
  in_port        = [22, 5000, 80]
  in_cidr        = "0.0.0.0/0"
  out_port       = 0
  out_protocol   = "-1"
  in_protocol    = "tcp"
  out_cidr       = "0.0.0.0/0"

  # @@@ TAGS @@@
  name_tag = "port_access"
  network_tag = "Bridge"
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@ Create IAM role @@@@@@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

module "iam" {
  source = "./IAM"
  iam_name = "AWSResourcePolicies"
  iam_desc = "aws_iam_role provision"
}

module "iam_policy" {
  source = "./IAM/POLICY/ATTACH"
  name = "AWSResourcePolicy"
  desc = "Policy used in conjunction with IAM Role"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

module "iam_policy_1" {
    source = "./IAM/POLICY"
    iam_pol_role = module.iam.name
    iam_pol_arn = module.iam_policy.arn
  }

module "iam_policy_2" {
    source = "./IAM/POLICY"
    iam_pol_role = module.iam.name
    iam_pol_arn = module.iam_policy.arn
  }

module "iam_policy_3" {
    source = "./IAM/POLICY"
    iam_pol_role = module.iam.name
    iam_pol_arn = module.iam_policy.arn
  }

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@ Create EC2 Instance @@@@@@@
# @@@@@@@       Manager       @@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

module "ec2_bridge" {
  source         = "./EC2"
  instance_count = "1"
  ami_code       = "ami-08bac620dc84221eb" # Ubuntu 20.04
  type_code      = "t2.micro"            # 1 x CPU + 1 x RAM
  pem_key        = "Bridge"
  subnet         = module.subnet_main.id
  vpc_sg         = [module.sg.id]
  pub_ip         = true
  lock           = var.locked
  user_data     = templatefile("./../../scripts/ec2-user/bridge.sh", {
    git_email = var.git_mail
    git_user = var.git_user
    project_name = var.git_pro
    aws_access = var.aws_ac
    aws_sec_access = var.aws_sec_ac
    aws_location = var.aws_location
  })

  # @@@ TAGS @@@
  name_tag = "Bridge"
  network_tag = "Bridge"
}