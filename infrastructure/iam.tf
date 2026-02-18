data "aws_eks_cluster" "vprofile" {
  name       = "vprofile-eks"
  depends_on = [module.eks]
}

data "aws_iam_openid_connect_provider" "vprofile_oidc" {
  url = data.aws_eks_cluster.vprofile.identity[0].oidc[0].issuer
}


resource "aws_iam_policy" "cluster_autoscaler" {
  name        = "${var.project_name}-cluster-autoscaler"
  description = "Permissions for EKS Cluster Autoscaler"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}


module "autoscaler_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${var.project_name}_cluster_autoscaler"

  oidc_providers = {
    main = {
      provider_arn               = data.aws_iam_openid_connect_provider.vprofile_oidc.arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }

  role_policy_arns = {
    policy = aws_iam_policy.cluster_autoscaler.arn
  }
}