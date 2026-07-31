terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.mi_region_aws
}

locals {
  nombre_workspace = terraform.workspace
  ruta_private_key = "~/Downloads/EjemploAnsible.pem"
  nombre_key       = "EjemploAnsible"
  usuario_ssh      = "ubuntu"
}

resource "aws_instance" "mi_servidor" {
  count		= terraform.workspace == "produccione" ? 3 : 2
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.micro"
  # data.aws_subnet.default.id
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [module.security-group.security_group_id]
  associate_public_ip_address = true
  key_name                    = local.nombre_key
  tags = {
    Name        = "${terraform.workspace}-${count.index}"
  }
  provisioner "remote-exec" {
    inline = ["echo 'Esperando conexion SSH en ${self.public_ip}'"]
    connection {
      type        = "ssh"
      user        = local.usuario_ssh
      private_key = file(pathexpand(local.ruta_private_key))
      host        = self.public_ip
      timeout     = "5m"
    }
  }

  provisioner "local-exec" {
    environment = {
      ANSIBLE_CONFIG = "${path.module}/ansible.cfg"
    }
    command = "ansible-playbook -i ${self.public_ip}, --private-key ${local.ruta_private_key} main.yml"
  }
}

resource "aws_cloudwatch_log_group" "grupo_log_ec2" {
  tags = {
    Environment = "default"
    Servicio    = "cloudwatch_spring"
  }
  lifecycle {
    create_before_destroy = true
  }
}
