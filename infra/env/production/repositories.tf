resource "google_cloudbuildv2_connection" "platform" {
  location = var.build_region
  name     = "platform"

  github_config {
    app_installation_id = var.github_app_installation_id

    authorizer_credential {
      oauth_token_secret_version = google_secret_manager_secret_version.github_token_secret_version.id
    }
  }

  depends_on = [google_secret_manager_secret_iam_policy.policy]
}

data "github_repository" "platform" {
  name = var.github_repository_name
}

resource "google_cloudbuildv2_repository" "platform" {
  location          = var.build_region
  name              = data.github_repository.platform.name
  parent_connection = google_cloudbuildv2_connection.platform.name
  remote_uri        = data.github_repository.platform.http_clone_url

  depends_on = [data.github_repository.platform]
}
