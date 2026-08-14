resource "google_container_cluster" "gke" {
    name               = "gke-cluster-gitops"
    location           = local.region
    remove_default_node_pool = true
    initial_node_count = 1
    network            = google_compute_network.vpc.self_link
    subnetwork         = google_compute_subnetwork.private.self_link
    networking_mode     = "VPC_NATIVE"

    deletion_protection = false

    node_locations = [
      "${local.region}-a"]

    addons_config {
      http_load_balancing {
        disabled = true
      }
      horizontal_pod_autoscaling {
        disabled = true
      }
    }

    release_channel {
      channel = "REGULAR"
    }

    workload_identity_config {
      workload_pool = "${var.project_id}.svc.id.goog"
    }

    ip_allocation_policy {
      cluster_secondary_range_name  = google_compute_subnetwork.private.secondary_ip_range[0].range_name
      services_secondary_range_name = google_compute_subnetwork.private.secondary_ip_range[1].range_name
    }

    private_cluster_config {
      enable_private_nodes    = true
      enable_private_endpoint = false
      master_ipv4_cidr_block  = "192.168.0.0/28"
    }
     # Jenkins use case
    # master_authorized_networks_config {
    #   cidr_blocks {
    #     cidr_block   = "10.0.0.0/18"
    #     display_name = "private-subnet"
    #   }
    # }
  
}