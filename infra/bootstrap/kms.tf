data "google_storage_project_service_account" "gcs_account" {

}

resource "google_kms_key_ring" "keyring" {
  location = var.gcp_region
  name     = var.gcp_project_id

  depends_on = [
    google_project_service.bootstrap
  ]
}

resource "google_kms_crypto_key" "state_backend" {
  key_ring = google_kms_key_ring.keyring.id
  name     = "state_backend"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key_iam_binding" "state_backend" {
  crypto_key_id = google_kms_crypto_key.state_backend.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}
