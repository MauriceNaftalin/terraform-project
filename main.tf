provider "aws" {
  version = "2.12.0"
  region = "eu-west-2"
  profile = "learningaws"
}
 
resource "aws_instance" "helloworld" {
  ami = "ami-0e80a462ede03e653"
  instance_type = "t2.micro"
}
