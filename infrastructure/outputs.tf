output "vpc_id" {
  value = module.vpc.vpc_id
}

output "nat_instance_public_ip" {
  value       = module.fck-nat.instance_public_ip
  description = "The public IP of the fck-nat instance"
}

output "fck_nat_eni_id" {
  value       = module.fck-nat.eni_id
  description = "The ENI ID used for private routing"
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}


output "lbc_role_arn" {
  description = "The ARN of the IAM role for the Load Balancer Controller"
  value       = module.eks.lbc_role_arn
}