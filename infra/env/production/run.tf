resource "google_cloud_run_v2_service" "frontend" {
  name                = "frontend"
  location            = var.region
  deletion_protection = true
  ingress             = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      resources {
        cpu_idle = true
        limits = {
          cpu    = "2000m"
          memory = "1Gi"
        }
      }
      volume_mounts {
        name       = "secrets"
        mount_path = "/secrets"
      }
      volume_mounts {
        mount_path = "/cloudsql"
        name       = "cloudsql"
      }
    }

    volumes {
      name = "secrets"
      secret {
        secret = google_secret_manager_secret.env_frontend.secret_id
        items {
          version = "latest"
          path    = "env"
          mode    = 0 # use default 0444
        }
      }
    }

    volumes {
      name = "cloudsql"

      cloud_sql_instance {
        instances = [google_sql_database_instance.project.connection_name]
      }
    }
  }

  lifecycle {
    ignore_changes = [
      client,
      client_version,
      template[0].containers[0].name,
      template[0].containers[0].image
    ]
  }

  depends_on = [
    google_secret_manager_secret.env_frontend
  ]
}

data "google_iam_policy" "public_access" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_v2_service.frontend.location
  project  = google_cloud_run_v2_service.frontend.project
  service  = google_cloud_run_v2_service.frontend.name

  policy_data = data.google_iam_policy.public_access.policy_data
}
