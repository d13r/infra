terraform {
  backend "s3" {
    region       = "eu-west-1"
    bucket       = "d13r-tofu-state"
    key          = "terraform.tfstate"
    encrypt      = true
    use_lockfile = true
  }
}
