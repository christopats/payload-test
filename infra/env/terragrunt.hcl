generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_version = ">= 1.3"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.4"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 6.4"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}
EOF
}

remote_state {
  backend = "gcs"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "payload-test-444215-tfstate"
    prefix = path_relative_to_include()
  }
}
