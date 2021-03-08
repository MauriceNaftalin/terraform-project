data "aws_availability_zones" "available" {}
 
module "vpc" {
  source                           = "terraform-aws-modules/vpc/aws"
  version                          = "2.5.0"
  name                             = "${var.namespace}-vpc"
  cidr                             = "172.16.0.0/16"
  azs                              = data.aws_availability_zones.available.names
  public_subnets                   = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  private_subnets                  = ["172.16.5.0/24", "172.16.6.0/24", "172.16.7.0/24"]
  database_subnets                 = ["172.16.9.0/24", "172.16.10.0/24", "172.16.11.0/24"]
  assign_generated_ipv6_cidr_block = true
  create_database_subnet_group     = false
  enable_nat_gateway               = true
  single_nat_gateway               = false
}

resource "aws_security_group" "AppSG" {
  name        = "AppSG"
  description = "Allow Internet web traffic, SSH from bastion host"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from bastion host"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = module.vpc.public_subnets_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "BastionSG" {
   name        = "bastion_sg"
   description = "Allow SSH from Admin IP"
   vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from Adming IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["86.164.29.35/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

