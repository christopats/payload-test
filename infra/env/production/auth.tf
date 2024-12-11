resource "google_identity_platform_config" "auth" {
  provider = google-beta
  project  = google_project.platform.project_id

  #   sign_in {
  #     allow_duplicate_emails = false
  # 
  #     email {
  #       enabled           = true
  #       password_required = true
  #     }
  #   }

  authorized_domains = [
    var.domain_name,
    "${google_project.platform.project_id}.firebaseapp.com",
    "${google_project.platform.project_id}.web.app",
  ]

  depends_on = [
    google_project_service.platform,
  ]
}
