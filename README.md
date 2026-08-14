# platform-infra terraform

Terraform config that provisions a GKE cluster and supporting network
infrastructure on GCP: a custom VPC with public/private subnets, Cloud NAT,
IAP-only SSH firewall rule, a private GKE cluster with a dedicated node
service account, and Helm-managed `ingress-nginx` and `cert-manager`
releases installed into the cluster.

## Layout

Files are numbered in apply order:

| File                    | Purpose                                             |
| ------------------------ | ---------------------------------------------------- |
| `0-locals.tf`            | Local values (project id, region, enabled APIs)     |
| `1-providers.tf`         | Google provider, Terraform/backend config           |
| `2-apis.tf`               | Enables required GCP APIs                            |
| `3-vpc.tf`                | VPC network + default route                          |
| `4-subnets.tf`            | Public/private subnets, GKE pod/service ranges       |
| `5-nat.tf`                | Cloud Router + Cloud NAT for the private subnet      |
| `6-firewalls.tf`          | IAP-only SSH ingress rule                             |
| `7-gke.tf`                 | Private GKE cluster                                   |
| `8-gke-nodes.tf`           | GKE service account, IAM bindings, node pool          |
| `9-nginx-ingress.tf`       | `ingress-nginx` Helm release                          |
| `10-cert-manager.tf`       | `cert-manager` Helm release                           |
| `variables.tf`             | Input variable declarations                           |

State is stored remotely in the `gitops-gke-tfstate` GCS bucket
(prefix `terraform/state`), configured in `1-providers.tf`.

## Prerequisites

- Terraform >= 1.0
- A GCP project with billing enabled, and credentials with permission to
  create the resources above (`gcloud auth application-default login` or a
  service account key via `GOOGLE_APPLICATION_CREDENTIALS`)
- Access to the `gitops-gke-tfstate` GCS bucket used for remote state

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars with your project id / region / vpc name

terraform init
terraform plan
terraform apply
```

### Variables

| Name         | Description                          | Default         |
| ------------ | ------------------------------------- | ---------------- |
| `project_id` | GCP project ID to deploy into         | *(required)*     |
| `region`     | GCP region to deploy into             | `us-central1`    |
| `vpc_name`   | VPC name                              | `main`           |

After apply, fetch cluster credentials with:

```bash
gcloud container clusters get-credentials gke-cluster-gitops --region <region> --project <project_id>
```
