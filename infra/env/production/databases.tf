resource "google_firestore_database" "platform" {
  provider = google-beta
  project  = google_project.platform.project_id
  name     = "(default)"
  # See available locations: https://firebase.google.com/docs/projects/locations#default-cloud-location
  location_id = var.region
  # "FIRESTORE_NATIVE" is required to use Firestore with Firebase SDKs, authentication, and Firebase Security Rules.
  type             = "FIRESTORE_NATIVE"
  concurrency_mode = "OPTIMISTIC"

  # Wait for Firebase to be enabled in the Google Cloud project before initializing Firestore.
  depends_on = [
    google_firebase_project.platform,
  ]
}
