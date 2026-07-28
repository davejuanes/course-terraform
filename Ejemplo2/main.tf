terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 6.0"
        }
    }
}

provider "aws" {
  region = "var.region_aws"
}

resource "aws_instance" "mi_servidor" {
  ami           = ""
  instance_type = "t2.micro"
}