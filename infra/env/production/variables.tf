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
