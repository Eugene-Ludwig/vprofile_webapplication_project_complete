output "vpc_id" {
  value = module.vpc.vpc_id
}

output "nat_instance_public_ip" {
  value       = module.fck-nat.instance_public_ip
  description = "The public IP of the fck-nat instance"
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}
