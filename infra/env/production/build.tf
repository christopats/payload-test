
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

resource "google_service_account" "cloudbuild_service_account" {
  account_id = "cloudbuild"

  depends_on = [google_project_service.platform]
}

resource "google_project_iam_member" "cloudbuild_roles" {
  project = google_project.platform.id
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
  for_each = toset([
    "roles/artifactregistry.reader",
    "roles/artifactregistry.writer",
    #     "roles/cloudbuild.workerPoolUser",
    "roles/cloudsql.client",
    "roles/firebase.admin",
    "roles/iam.serviceAccountUser",
    "roles/logging.logWriter",
    "roles/run.developer",
    "roles/secretmanager.admin"
  ])
  role = each.value

  depends_on = [
    google_project_service.platform,
    google_artifact_registry_repository.platform
  ]
}

resource "google_cloudbuild_trigger" "deploy" {
  name            = "deploy"
  location        = var.build_region
  service_account = google_service_account.cloudbuild_service_account.id
  filename        = "cloudbuild.deploy.yaml"

  repository_event_config {
    repository = google_cloudbuildv2_repository.platform.id

    push {
      branch = "main"
    }
  }

  depends_on = [
    google_project_iam_member.cloudbuild_roles
  ]
}

resource "google_cloudbuild_trigger" "base" {
  name            = "base"
  location        = var.build_region
  service_account = google_service_account.cloudbuild_service_account.id
  filename        = "cloudbuild.base.yaml"

  repository_event_config {
    repository = google_cloudbuildv2_repository.platform.id

    push {
      tag = "^build-\\d+.\\d+.\\d+-\\d+.\\d+$"
    }
  }

  depends_on = [
    google_project_iam_member.cloudbuild_roles
  ]
}
