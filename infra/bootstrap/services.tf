resource "google_project_service" "bootstrap" {
  for_each = toset([
    "cloudbilling.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "logging.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com",
  ])
  service = each.key

  disable_on_destroy = false
}