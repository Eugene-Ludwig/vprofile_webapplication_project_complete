module "vpc" {
  source             = "./modules/vpc"
  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  database_subnets   = var.database_subnets
  cluster_name       = var.cluster_name

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}


module "fck-nat" {
  source  = "RaJiska/fck-nat/aws"
  version = "1.3.0"

  name   = "${var.project_name}-fck-nat"
  vpc_id = module.vpc.vpc_id

  subnet_id = module.vpc.public_subnets[0]

  update_route_tables = false
  instance_type       = "t4g.nano"
  ha_mode             = false

}

resource "aws_route" "private_nat_route" {
  for_each               = { for idx, id in module.vpc.private_route_table_ids : idx => id }
  route_table_id         = each.value
  destination_cidr_block = "0.0.0.0/0"

  network_interface_id = module.fck-nat.eni_id
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = var.cluster_name
  project_name    = var.project_name
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  is_local_run    = var.is_local_run

  depends_on = [module.vpc, aws_route.private_nat_route]
}
