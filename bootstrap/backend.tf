terraform {
  backend "s3" {
    bucket         = "vprofile-terraform-state-2026"
    key            = "bootstrap/terraform.tfstate"
    region         = "eu-south-2"                    
    dynamodb_table = "vprofile-terraform-locks"
    encrypt        = true
  }
}