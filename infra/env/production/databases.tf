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

resource "google_sql_database_instance" "project" {
  name                = "project"
  region              = var.region
  database_version    = "POSTGRES_17"
  deletion_protection = true

  settings {
    tier                        = "db-f1-micro"
    disk_size                   = 10
    disk_type                   = "PD_SSD"
    availability_type           = "ZONAL"
    edition                     = "ENTERPRISE"
    deletion_protection_enabled = true
    activation_policy           = "ALWAYS"

    backup_configuration {
      location                       = var.region
      enabled                        = true
      point_in_time_recovery_enabled = true
      start_time                     = "02:00"
      transaction_log_retention_days = 3
    }

    maintenance_window {
      day  = 7
      hour = 3
    }
  }

  depends_on = [
    google_project_service.platform
  ]
}

resource "google_sql_database" "app" {
  instance = google_sql_database_instance.project.id
  name     = "app"
}

resource "random_password" "postgres_system" {
  length           = 20
  special          = true
  override_special = "!@#$%&*+"
}

resource "google_sql_user" "system" {
  instance = google_sql_database_instance.project.id
  name     = "system"
  password = random_password.postgres_system.result
}
