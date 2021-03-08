provider "aws" {
  version = "2.12.0"
  region = "eu-west-2"
  profile = "manningproject"
}
 
resource "aws_instance" "bastion-host" {
  ami = "ami-0e80a462ede03e653"
  instance_type = "t2.micro"
  vpc_security_group_ids = [var.sg.bastion]
  count = 3
  subnet_id = element(var.subnet_ids.public, count.index)
  key_name = "manning-second"
}

resource "aws_instance" "app-host" {
  ami = "ami-0e80a462ede03e653"
  instance_type = "t2.micro"
  vpc_security_group_ids = [var.sg.app]
  count = 3
  subnet_id = element(var.subnet_ids.private, count.index)
  key_name = "manning-second"
}
