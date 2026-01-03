terraform {
  backend "s3" {
    bucket       = "terraform-state-1767358640"
    key          = "pre-prod/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}