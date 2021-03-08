output "vpc" {
  value = module.vpc
}

output "bastion_sg_id" {
  value = aws_security_group.BastionSG.id
}

output "sg" {
  value = {
     bastion = aws_security_group.BastionSG.id
     app = aws_security_group.AppSG.id
  }
}

output "subnet_ids" {
  value = {
     private = module.vpc.private_subnets
     public  = module.vpc.public_subnets
  }
}
