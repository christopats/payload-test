
resource "google_project_service" "platform" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com"
  ])
  service = each.key

  disable_on_destroy = false
}
