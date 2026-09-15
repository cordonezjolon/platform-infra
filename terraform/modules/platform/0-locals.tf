locals {
  project_id = var.project_id
  region     = var.region
  apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "logging.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}
