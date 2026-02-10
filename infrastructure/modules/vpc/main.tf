module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr


  azs              = var.availability_zones
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets

  create_database_subnet_route_table = true

  enable_nat_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  manage_default_route_table = true

  private_route_table_tags = {
    Name = "${var.project_name}-vpc-private"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  database_subnet_tags = {
    "Name" = "${var.project_name}-db-subnet"
  }

  tags = {
    Project     = var.project_name
    Environment = "dev"
  }
}
