# platform-infra terraform

Terraform config that provisions a GKE cluster and supporting network
infrastructure on GCP: a custom VPC with public/private subnets, Cloud NAT,
IAP-only SSH firewall rule, a private GKE cluster with a dedicated node
service account, Helm-managed `ingress-nginx`, `cert-manager`, and Argo CD
releases installed into the cluster, a Workload Identity Federation setup
for keyless GitHub Actions authentication, and the Doppler Kubernetes
Operator for syncing secrets into the cluster.

## Layout

Files are numbered in apply order:

| File                        | Purpose                                                        |
| ---------------------------- | ---------------------------------------------------------------- |
| `0-locals.tf`                | Local values (project id, region, enabled APIs)                |
| `1-providers.tf`             | Google provider, Terraform/backend config                      |
| `2-apis.tf`                  | Enables required GCP APIs                                      |
| `3-vpc.tf`                   | VPC network + default route                                    |
| `4-subnets.tf`               | Public/private subnets, GKE pod/service ranges                 |
| `5-nat.tf`                   | Cloud Router + Cloud NAT for the private subnet                |
| `6-firewalls.tf`             | IAP-only SSH ingress rule                                      |
| `7-gke.tf`                   | Private GKE cluster                                             |
| `8-gke-nodes.tf`             | GKE service account, IAM bindings, node pool                   |
| `9-nginx-ingress.tf`         | `ingress-nginx` Helm release                                    |
| `10-cert-manager.tf`         | `cert-manager` Helm release                                     |
| `11-github-actions-sa.tf`    | GitHub Actions service account + Workload Identity Federation pool/provider |
| `12-argocd.tf`                | `argo-cd` Helm release                                           |
| `13-doppler.tf`               | Doppler Kubernetes Operator, and a `DopplerSecret` syncing the `books-go-api` dev config |
| `variables.tf`                | Input variable declarations                                     |

State is stored remotely in the `gitops-gke-tfstate` GCS bucket
(prefix `terraform/state`), configured in `1-providers.tf`.

## Prerequisites

- Terraform >= 1.9
- A GCP project with billing enabled, and credentials with permission to
  create the resources above (`gcloud auth application-default login` or a
  service account key via `GOOGLE_APPLICATION_CREDENTIALS`)
- Access to the `gitops-gke-tfstate` GCS bucket used for remote state
- A Doppler service token for the `books-go-api` project (`dev` config)

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars with your project id / region / vpc name / doppler token

terraform init
terraform plan
terraform apply
```

### Variables

| Name                     | Description                                                                                | Default         |
| ------------------------- | --------------------------------------------------------------------------------------------- | ---------------- |
| `project_id`              | GCP project ID to deploy into                                                               | *(required)*     |
| `region`                  | GCP region to deploy into                                                                    | `us-central1`    |
| `vpc_name`                | VPC name, and prefix used for the GitHub Actions SA / WIF pool and provider names            | `main`           |
| `doppler_service_token`   | Doppler service token (project: `books-go-api`, config: `dev`) used by the Doppler Kubernetes Operator to sync secrets | *(required, sensitive)* |

After apply, fetch cluster credentials with:

```bash
gcloud container clusters get-credentials gke-cluster-gitops --region <region> --project <project_id>
```

## GitHub Actions / Workload Identity Federation

`11-github-actions-sa.tf` provisions a keyless CI setup: a
`github-actions` GCP service account with `roles/editor`, plus a Workload
Identity Pool and OIDC provider trusting GitHub's token issuer. The
attribute condition restricts token exchange to a specific repository and
actor (`cordonezjolon/platform-infra`, actor `cordonezjolon`) — update it if
forking or reusing this config. The resource outputs
`workload_identity_provider` and `service_account_email`, which back the
`WIF_PROVIDER` / `WIF_SERVICE_ACCOUNT` secrets used by the CI workflow below.

## CI/CD

[.github/workflows/terraform.yml](.github/workflows/terraform.yml) runs on
push/PR to `main`, `stage`, and `develop`, plus manual dispatch:

- **terraform-plan**: authenticates to GCP via WIF, runs `terraform fmt
  -check`, `terraform validate`, and `terraform plan`, then uploads the plan
  as a build artifact. Runs in the `./terraform` working directory on every
  push and PR.
- **apply**: only runs on manual `workflow_dispatch` against `main`
  (`production` environment). Re-authenticates via WIF, downloads the saved
  plan, and runs `terraform apply -auto-approve` against it.

Required repository secrets: `TF_VAR_project_id`, `TF_VAR_region`,
`TF_VAR_vpc_name`, `TF_VAR_doppler_service_token`, `WIF_PROVIDER`,
`WIF_SERVICE_ACCOUNT`.
