resource "google_artifact_registry_repository" "platform" {
  location      = var.region
  repository_id = "platform"
  description   = "Platform artifacts"
  format        = "DOCKER"

  depends_on = [google_project_service.platform]
}
