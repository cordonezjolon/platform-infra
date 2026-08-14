resource "google_service_account" "gke" {
    account_id   = "svc-${var.project_id}-gke"
  
}

resource "google_project_iam_member" "gke_logging" {
    project = local.project_id
    role    = "roles/logging.logWriter"
    member  = "serviceAccount:${google_service_account.gke.email}"
}

resource "google_project_iam_member" "gke_metrics" {
    project = local.project_id
    role    = "roles/monitoring.metricWriter"
    member  = "serviceAccount:${google_service_account.gke.email}"
}

resource "google_container_node_pool" "general" {
    name           = "general"
    cluster        = google_container_cluster.gke.id
    node_locations = ["${local.region}-a"]

    autoscaling {
        min_node_count = 1
        max_node_count = 4       
    }

    management {
        auto_repair  = true
        auto_upgrade = true
    }

    node_config {
        preemptible  = false // learn more 
        machine_type = "e2-standard-2"

        labels = {
            env = "dev"
            role = "general"
        }
        service_account = google_service_account.gke.email
        oauth_scopes = [
            "https://www.googleapis.com/auth/cloud-platform",
        ]

    }  
}