resource "helm_release" "argocd" {
  count = var.enable_argocd ? 1 : 0

  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "${path.module}/argo-cd-10.3.0.tgz"
  version    = var.argocd_chart_version

  namespace        = "argocd"
  create_namespace = true

  wait    = true
  timeout = 900

  values = [
    yamlencode({
      configs = {
        params = {
          "server.insecure" = true
        }
      }

      server = {
        service = {
          type = "ClusterIP"
        }
      }
    })
  ]

  depends_on = [module.eks]
}
