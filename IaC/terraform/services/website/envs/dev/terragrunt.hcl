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

  extra_arguments "vars" {
    commands = [
      "plan",
      "apply",
      "import",
      "push",
      "refresh",
      "destroy"
    ]

    required_var_files = [
      "${get_terragrunt_dir()}/../../src/dev.tfvars"
    ]
  }
}

inputs = {
  delete_bucket_hosting = true
}