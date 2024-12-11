resource "google_secret_manager_secret" "github_token_secret" {
  secret_id = "github-token-secret"

  replication {
    auto {}
  }

  depends_on = [google_project_service.platform]
}

resource "google_secret_manager_secret_version" "github_token_secret_version" {
  secret      = google_secret_manager_secret.github_token_secret.id
  secret_data = file("${path.module}/secrets/github_token.txt")

  #   lifecycle {
  #     ignore_changes = [
  #       secret_data
  #     ]
  #   }
}

resource "google_secret_manager_secret" "env_frontend" {
  secret_id = "env-frontend"

  replication {
    auto {}
  }

  depends_on = [google_project_service.platform]
}

resource "google_secret_manager_secret_version" "env_frontend" {
  secret      = google_secret_manager_secret.env_frontend.id
  secret_data = file("${path.module}/secrets/env_frontend.txt")

  lifecycle {
    ignore_changes = [
      secret_data
    ]
  }
}

