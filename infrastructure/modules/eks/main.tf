data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  cluster_endpoint_public_access_cidrs = ["${chomp(data.http.myip.response_body)}/32"]

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.private_subnets

  enable_irsa = true

  enable_cluster_creator_admin_permissions = true
  authentication_mode                      = "API_AND_CONFIG_MAP"

  access_entries = var.is_local_run ? {} : {
    ludwig_admin = {
      principal_arn = "arn:aws:iam::730335639573:user/kops_admin"
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description = "Node all egress"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  eks_managed_node_groups = {
    system = {
      name           = "system-nodes"
      instance_types = ["t3.small"]
      capacity_type  = "SPOT"
      min_size       = 1
      max_size       = 2
      desired_size   = 1

      ami_type = "AL2_x86_64"

      tags = {
        "k8s.io/cluster-autoscaler/enabled"             = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
      }

      labels = {
        "role" = "system"
      }
    }

    workload = {
      name           = "workload-nodes"
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
      min_size       = 1
      max_size       = 2
      desired_size   = 1

      ami_type = "AL2_x86_64"

      pre_bootstrap_user_data = <<-EOT
        export USE_MAX_PODS=false
      EOT

      tags = {
        "k8s.io/cluster-autoscaler/enabled"             = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
      }

      labels = {
        "role" = "workload"
      }

    }
  }


  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  tags = {
    Environment = "dev"
    Project     = var.project_name
  }
}