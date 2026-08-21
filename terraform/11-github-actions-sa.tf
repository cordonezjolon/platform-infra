resource "google_service_account" "github_actions" {
    account_id   = "${var.vpc_name}-github-actions"
    display_name = "GitHub Actions Service Account"
    project      = local.project_id
     
}

resource "google_project_iam_member" "github_actions_editor" {
    project = local.project_id
    role    = "roles/editor"
    member  = "serviceAccount:${google_service_account.github_actions.email}"
  
}


resource "google_iam_workload_identity_pool" "github" {
    workload_identity_pool_id = "${var.vpc_name}-git-act-pool"
    display_name              = "GitHub Identity Pool"
    project                   = local.project_id
  
}

resource "google_iam_workload_identity_pool_provider" "github" {

    workload_identity_pool_id = google_iam_workload_identity_pool.github.workload_identity_pool_id
    workload_identity_pool_provider_id = "${var.vpc_name}-git-act-provider"
    project                   = local.project_id
    display_name              = "GitHub Identity Provider"
    oidc {
        issuer_uri = "https://token.actions.githubusercontent.com"
    }
    attribute_mapping = {
        "google.subject" = "assertion.sub"
        "attribute.actor" = "assertion.actor"
        "attribute.repository" = "assertion.repository"
    }
    attribute_condition = "assertion.repository == 'cordonezjolon/platform-infra' && assertion.actor == 'cordonezjolon'"

   }


output "workload_identity_provider" {
  value = google_iam_workload_identity_pool_provider.github.name
}

output "service_account_email" {
  value = google_service_account.github_actions.email
}