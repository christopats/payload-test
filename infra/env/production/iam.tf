
data "google_compute_default_service_account" "platform" {
  depends_on = [google_project_service.platform]
}

resource "google_project_iam_member" "firebase_admin_sign_blob" {
  project = google_project.platform.id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${data.google_compute_default_service_account.platform.email}"
}

resource "google_secret_manager_secret_iam_member" "env_frontend" {
  secret_id = google_secret_manager_secret.env_frontend.id
  role      = "roles/secretmanager.secretAccessor"

  // TODO: Use a specific service account for the frontend run instance
  member     = "serviceAccount:${data.google_compute_default_service_account.platform.email}"
  depends_on = [google_secret_manager_secret.env_frontend]
}

