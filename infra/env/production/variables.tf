variable "project_id" {
  type    = string
  default = "payload-test-444215"
}

variable "region" {
  type    = string
  default = "europe-west2"
}

variable "github_organisation" {
  type        = string
  description = "The GitHub organisation"
  default     = "christopats"
}

variable "project_name" {
  type    = string
  default = "payload-test-444215"
}


variable "billing_account" {
  type    = string
  default = "01A9E0-6AD7CA-B5E6E1"
}

variable "domain_name" {
  type    = string
  default = "tincoast.io"
}

variable "build_region" {
  type    = string
  default = "europe-west1"
}

variable "github_repository_name" {
  type    = string
  default = "payload-test"
}


variable "github_app_installation_id" {
  type    = number
  default = "58222058"
}