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


