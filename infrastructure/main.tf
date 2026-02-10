module "vpc" {
  source             = "./modules/vpc"
  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  database_subnets   = var.database_subnets
  cluster_name       = var.cluster_name
}

data "aws_route_table" "private" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-vpc-private"]
  }
  depends_on = [module.vpc]
}

module "fck-nat" {
  source  = "RaJiska/fck-nat/aws"
  version = "1.4.0"

  name   = "${var.project_name}-fck-nat"
  vpc_id = module.vpc.vpc_id

  subnet_id = module.vpc.public_subnets[0]

  update_route_tables = true
  route_table_id      = data.aws_route_table.private.id

  instance_type = "t4g.nano"

  depends_on = [module.vpc]
}
