variable "project_id" {
  type        = string
  description = "GCP project ID to deploy resources into."
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "GCP region to deploy resources into."
}

variable "vpc_name" {
  type        = string
  default     = "main"
  description = "VPC name to deploy resources into."
}

variable "doppler_service_token" {
  type        = string
  sensitive   = true
  description = "Doppler Service Token (project: books-go-api, config: dev) used by the Doppler Kubernetes Operator to sync secrets."
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, stage, prod)."
}

variable "cluster_name" {
  type        = string
  description = "GKE cluster name. Set explicitly per environment (renaming forces cluster replacement)."
}


