# data "aws_caller_identity" "current" {}
# data "aws_partition" "current" {}

# locals {
#   account_id = data.aws_caller_identity.current.account_id
#   partition  = data.aws_partition.current.partition
# }

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = "1.31"

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.private_subnets

  enable_irsa = true

  enable_cluster_creator_admin_permissions = true
  authentication_mode                      = "API_AND_CONFIG_MAP"
  
  # access_entries = {
  #   node_access = {
  #     principal_arn = module.eks.eks_managed_node_groups["vprofile_nodes"].iam_role_arn
  #     type          = "EC2_LINUX"
  #   }
  # }

  eks_managed_node_groups = {
    vprofile_nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      pre_bootstrap_user_data = <<-EOT
      export USE_MAX_PODS=false
      export AWS_DEFAULT_REGION=eu-central-1
      export AWS_STS_REGIONAL_ENDPOINTS=regional
    EOT

      # create_iam_role = true
      # iam_role_name   = "${var.cluster_name}-node-role"
      # iam_role_additional_policies = {
      #   AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
      #   AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      #   AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      # }
      
      iam_role_name = "${var.cluster_name}-node-role"

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"

      labels = {
        role = "worker"
      }
    }
  }


  addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
    aws-ebs-csi-driver = {}
  }

  tags = {
    Environment = "dev"
    Project     = var.project_name
  }
}
