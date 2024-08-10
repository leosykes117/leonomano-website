include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../..//src"

  extra_arguments "init_args" {
    commands = [
      "init"
    ]

    arguments = [
      "-backend-config=${abspath("${get_terragrunt_dir()}/../../src/dev.s3.tfbackend")}",
    ]
  }
}

inputs = {
  domain_name           = "leonomano.com"
  aws_profile           = "website"
  delete_bucket_hosting = true
}