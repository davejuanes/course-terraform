module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"

  name                 = "TerraformVPC"
  cidr                 = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_vpn_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Terraform   = "true"
    Environment = "Dev"
  }
}
module "security-group" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "5.3.1"
  name                = "Regla Https"
  description         = "Security Group de Dave"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["https-443-tcp"]
}