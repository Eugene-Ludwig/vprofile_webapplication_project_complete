resource "aws_route53_zone" "main" {
  name          = var.domain_name
  force_destroy = false

  tags = {
    Project     = "vprofile"
    Environment = "bootstrap"
  }
}