terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  # profile = "root-acc"
  region = var.mi_region_aws
}

locals {
  Environment      = "Dev"
  nombre_workspace = terraform.workspace
}

#data "aws_subnet" "default" {
#  default_for_az = true
#}

resource "aws_instance" "mi_servidor" {
  for_each      = var.nombres_servicios
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.micro"
  # data.aws_subnet.default.id
  subnet_id                   = module.vpc.public_subnets[0] # "subnet-0dba02e7cfd16b7a1"
  vpc_security_group_ids      = [module.security-group.security_group_id]
  associate_public_ip_address = true # Publica la IP privada
  tags = {
    Name        = "ServidorTerraform-${each.key}"
    Environment = local.Environment
    Owner       = "Dave"
  }
}

resource "aws_instance" "mi_servidor2" {
  count         = terraform.workspace == "produccione" ? 2 : 1
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.micro"
  # data.aws_subnet.default.id
  subnet_id                   = module.vpc.public_subnets[1] # "subnet-0dba02e7cfd16b7a1"
  vpc_security_group_ids      = [module.security-group.security_group_id]
  associate_public_ip_address = true # Publica la IP privada
  tags = {
    Name        = format("%s-%s", terraform.workspace, count.index) # "${terraform.workspace}-${count.index}"
    Environment = local.Environment
    Owner       = "Dave"
  }
}

resource "aws_cloudwatch_log_group" "grupo_log_ec2" {
  for_each = var.nombres_servicios
  tags = {
    Environment = "Prueba"
    Servicio    = each.key
  }
  lifecycle {
    create_before_destroy = true
  }
}
