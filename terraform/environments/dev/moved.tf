moved {
  from = google_compute_address.nat
  to   = module.platform.google_compute_address.nat
}

moved {
  from = google_compute_firewall.allow_iap_ssh
  to   = module.platform.google_compute_firewall.allow_iap_ssh
}

moved {
  from = google_compute_network.vpc
  to   = module.platform.google_compute_network.vpc
}

moved {
  from = google_compute_route.default_route
  to   = module.platform.google_compute_route.default_route
}

moved {
  from = google_compute_router.router
  to   = module.platform.google_compute_router.router
}

moved {
  from = google_compute_router_nat.nat
  to   = module.platform.google_compute_router_nat.nat
}

moved {
  from = google_compute_subnetwork.private
  to   = module.platform.google_compute_subnetwork.private
}

moved {
  from = google_compute_subnetwork.public
  to   = module.platform.google_compute_subnetwork.public
}

moved {
  from = google_container_cluster.gke
  to   = module.platform.google_container_cluster.gke
}

moved {
  from = google_container_node_pool.general
  to   = module.platform.google_container_node_pool.general
}

moved {
  from = google_iam_workload_identity_pool.github
  to   = module.platform.google_iam_workload_identity_pool.github
}

moved {
  from = google_iam_workload_identity_pool_provider.github
  to   = module.platform.google_iam_workload_identity_pool_provider.github
}

moved {
  from = google_project_iam_member.github_actions_editor
  to   = module.platform.google_project_iam_member.github_actions_editor
}

moved {
  from = google_project_iam_member.gke_logging
  to   = module.platform.google_project_iam_member.gke_logging
}

moved {
  from = google_project_iam_member.gke_metrics
  to   = module.platform.google_project_iam_member.gke_metrics
}

moved {
  from = google_project_service.api["compute.googleapis.com"]
  to   = module.platform.google_project_service.api["compute.googleapis.com"]
}

moved {
  from = google_project_service.api["container.googleapis.com"]
  to   = module.platform.google_project_service.api["container.googleapis.com"]
}

moved {
  from = google_project_service.api["logging.googleapis.com"]
  to   = module.platform.google_project_service.api["logging.googleapis.com"]
}

moved {
  from = google_project_service.api["secretmanager.googleapis.com"]
  to   = module.platform.google_project_service.api["secretmanager.googleapis.com"]
}

moved {
  from = google_service_account.github_actions
  to   = module.platform.google_service_account.github_actions
}

moved {
  from = google_service_account.gke
  to   = module.platform.google_service_account.gke
}

moved {
  from = helm_release.argocd
  to   = module.platform.helm_release.argocd
}

moved {
  from = helm_release.cert-manager
  to   = module.platform.helm_release.cert-manager
}

moved {
  from = helm_release.doppler_operator
  to   = module.platform.helm_release.doppler_operator
}

moved {
  from = helm_release.nginx_ingress
  to   = module.platform.helm_release.nginx_ingress
}

moved {
  from = kubernetes_namespace.doppler_operator_system
  to   = module.platform.kubernetes_namespace.doppler_operator_system
}

moved {
  from = kubernetes_secret.doppler_token
  to   = module.platform.kubernetes_secret.doppler_token
}
