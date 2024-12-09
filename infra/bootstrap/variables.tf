variable "gcp_project_id" {
  description = "The project id on GCP"
  type        = string
  default     = "payload-test-444215"
}

variable "gcp_region" {
  description = "The location of resources on GCP"
  type        = string
  default     = "europe-west2"

  validation {
    condition     = contains(["europe-west2"], var.gcp_region)
    error_message = "Allowed values for gcp_region are \"europe-west2\""
  }
}