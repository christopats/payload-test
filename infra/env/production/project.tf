import {
  id = var.project_id
  to = google_project.platform
}

resource "google_project" "platform" {
  name       = var.project_name
  project_id = var.project_id
  #   org_id          = var.org_id
  billing_account = var.billing_account

  labels = {
    firebase = "enabled"
  }
}

resource "google_firebase_project" "platform" {
  provider = google-beta
  project  = google_project.platform.project_id

  depends_on = [
    google_project_service.platform
  ]
}
