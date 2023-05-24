provider "aws" {
  region                   = var.aws_region
  profile                  = var.aws_profile
  shared_credentials_files = length(var.shared_credentials_file) > 0 ? [var.shared_credentials_file] : null

  default_tags {
    tags = {
      Project = var.project_name
      App     = local.application
      Env     = var.env
    }
  }
}

provider "godaddy" {
  key    = var.godaddy_key
  secret = var.godaddy_secret
}