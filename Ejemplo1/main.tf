provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami = "ami-2342faf23a23f4"
  instance_type = "t2.micro"
}

