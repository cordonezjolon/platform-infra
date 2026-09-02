provider "kubernetes" {
  host                   = "https://${google_container_cluster.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.gke.master_auth[0].cluster_ca_certificate)
}

resource "kubernetes_namespace" "doppler_operator_system" {
  metadata {
    name = "doppler-operator-system"

    labels = {
      "app.kubernetes.io/managed-by" = "Helm"
    }

    annotations = {
      "meta.helm.sh/release-name"      = "doppler-kubernetes-operator"
      "meta.helm.sh/release-namespace" = "doppler-operator-system"
    }
  }
}

resource "helm_release" "doppler_operator" {
  name             = "doppler-kubernetes-operator"
  repository       = "https://helm.doppler.com"
  chart            = "doppler-kubernetes-operator"
  namespace        = kubernetes_namespace.doppler_operator_system.metadata[0].name
  create_namespace = false

  depends_on = [helm_release.argocd, kubernetes_namespace.doppler_operator_system]
}

resource "kubernetes_secret" "doppler_token" {
  metadata {
    name      = "doppler-token-books-go-api"
    namespace = "doppler-operator-system"
  }

  data = {
    serviceToken = var.doppler_service_token
  }

  type = "Opaque"

  depends_on = [helm_release.doppler_operator]
}


resource "kubernetes_manifest" "doppler_secret_books_go_api_namespace" {
  manifest = {
    apiVersion = "secrets.doppler.com/v1alpha1"
    kind       = "DopplerSecret"
    metadata = {
      name      = "books-go-api-doppler-secret"
      namespace = "doppler-operator-system"
    }
    spec = {
      project = "books-go-api"
      config  = "dev"
      tokenSecret = {
        name = kubernetes_secret.doppler_token.metadata[0].name
      }
      managedSecret = {
        name      = "books-go-api-secret"
        namespace = "books-api-development"
      }
    }
  }

  depends_on = [helm_release.doppler_operator, kubernetes_secret.doppler_token]
}