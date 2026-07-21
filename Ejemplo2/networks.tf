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
