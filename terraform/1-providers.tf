provider "google" {
  project = local.project_id
  region  = local.region
}

terraform {
  required_version = ">= 1.0"

  backend "gcs" {
    bucket = "gitops-gke-tfstate"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}