output "iam_role_arn" {
  value = module.github_oidc.iam_role_arn
}

output "route53_zone_id" {
  value = module.dns.zone_id
}

output "route53_nameservers" {
  value = module.dns.name_servers
}