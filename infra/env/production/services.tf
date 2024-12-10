
resource "google_project_service" "platform" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "firebase.googleapis.com",
    "firestore.googleapis.com",
    "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "cloudbuild.googleapis.com",
    "run.googleapis.com"

  ])
  service = each.key

  disable_on_destroy = false
}
