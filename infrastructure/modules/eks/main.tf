module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.private_subnets

  enable_cluster_creator_admin_permissions = true

  enable_irsa = true

  eks_managed_node_groups = {
    vprofile_nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"

      labels = {
        role = "worker"
      }
    }
  }


  cluster_addons = {
    coredns            = {}
    kube-proxy         = {}
    vpc-cni            = {}
    aws-ebs-csi-driver = {}
  }

  tags = {
    Environment = "dev"
    Project     = var.project_name
  }
}
