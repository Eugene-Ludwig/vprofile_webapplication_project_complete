variable "project_name" { type = string }
variable "cluster_name" { type = string }
variable "vpc_id" { type = string }
variable "private_subnets" { type = list(string) }

variable "is_local_run" {
  type        = bool
  default     = false
  description = "Set to true when running terraform apply from local machine to avoid EKS Access Entry conflicts."
}