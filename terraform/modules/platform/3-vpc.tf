resource "google_compute_network" "vpc" {
  name                            = var.vpc_name
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true

  depends_on = [
    google_project_service.api
  ]
}

resource "google_compute_route" "default_route" {
  name             = "${var.vpc_name}-default-route"
  network          = google_compute_network.vpc.name
  dest_range       = "0.0.0.0/0"
  next_hop_gateway = "default-internet-gateway"
}

