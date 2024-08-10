inputs = {
  project_name = "leonomano-website"
  env          = basename(path_relative_to_include())
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "leonomano-website-tf-state-378041425110-us-east-1"
    dynamodb_table = "leonomano-website-tf-state-378041425110-us-east-1"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true

    disable_bucket_update = true
  }
}