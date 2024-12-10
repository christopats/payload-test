data "google_iam_policy" "p4sa_secretAccessor" {
  binding {
    role    = "roles/secretmanager.secretAccessor"
    members = ["serviceAccount:service-${google_project.platform.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"]
  }

  depends_on = [google_project_service.platform]
}

resource "google_secret_manager_secret_iam_policy" "policy" {
  secret_id   = google_secret_manager_secret.github_token_secret.secret_id
  policy_data = data.google_iam_policy.p4sa_secretAccessor.policy_data
}
