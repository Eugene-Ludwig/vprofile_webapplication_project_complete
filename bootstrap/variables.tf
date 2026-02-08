variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "eu-south-2"
}

variable "state_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
  default     = "vprofile-terraform-state-2026"
}

variable "lock_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "vprofile-terraform-locks"
}