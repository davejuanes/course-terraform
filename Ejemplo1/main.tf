provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "Amazon Machine Image"
  instance_type = "t2.micro"
}