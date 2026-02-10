resource "aws_s3_bucket" "terraform_state" {
  bucket = var.state_bucket_name
  
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID" 

  attribute {
    name = "LockID"
    type = "S"
  }
}

module "github_oidc" {
  source    = "./modules/iam"
  repo_name = "Eugene-Ludwig/vprofile_webapplication_project_complete"
}

module "dns" {
  source      = "./modules/dns"
  domain_name = "ludwigdevops.site"
}