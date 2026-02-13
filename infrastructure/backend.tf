terraform {
  backend "s3" {
    bucket         = "vprofile-terraform-state-2026-frankfurt"
    key            = "infrastructure/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "vprofile-terraform-locks"
    encrypt        = true
  }
}