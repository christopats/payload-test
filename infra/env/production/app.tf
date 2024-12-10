
# Used only to ensure firestore has the correct storage bucket
resource "google_app_engine_application" "platform" {
  provider    = google-beta
  project     = google_project.platform.project_id
  location_id = var.region # Must be in the same location as Firestore (above)

  # Wait for Firestore to be provisioned first.
  # Otherwise, the Firestore instance will be provisioned in Datastore mode (unusable by Firebase).
  depends_on = [
    google_firestore_database.platform,
  ]
}

resource "google_firebase_web_app" "platform" {
  provider     = google-beta
  project      = google_project.platform.project_id
  display_name = var.project_name

  deletion_policy = "DELETE"

  depends_on = [
    google_firebase_project.platform
  ]
}

resource "google_firebase_hosting_custom_domain" "platform" {
  provider = google-beta

  project       = google_project.platform.project_id
  site_id       = google_project.platform.project_id
  custom_domain = var.domain_name

  wait_dns_verification = false

  depends_on = [
    google_firebase_web_app.platform
  ]
}

resource "google_firebase_hosting_custom_domain" "www_redirect" {
  provider = google-beta

  project         = google_project.platform.project_id
  site_id         = google_project.platform.project_id
  custom_domain   = "www.${var.domain_name}"
  redirect_target = var.domain_name

  wait_dns_verification = false

  depends_on = [
    google_firebase_hosting_custom_domain.platform,
    google_firebase_web_app.platform
  ]
}
