resource "google_storage_bucket" "backend_state" {
  location      = var.gcp_region
  name          = "${var.gcp_project_id}-tfstate"
  force_destroy = false
  storage_class = "STANDARD"

  versioning {
    enabled = true
  }

  encryption {
    default_kms_key_name = google_kms_crypto_key.state_backend.id
  }

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [
    google_project_service.bootstrap,
    google_kms_crypto_key_iam_binding.state_backend
  ]
}
