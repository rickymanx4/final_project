resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "node_exporter" {
  depends_on  = [kubernetes_namespace.monitoring]
  name        = "node-exporter"
  namespace   = kubernetes_namespace.monitoring.metadata[0].name
  repository  = "https://charts.bitnami.com/bitnami"
  chart       = "node-exporter"
  version     = "4.1.0"
  
  set {
    name  = "rbac.pspEnabled"
    value = "false"
  }
  set {
    name  = "serviceAccount.name"
    value = local.lb_controller_service_account_name 
  }
  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "ingress.enabled"
    value = "true"
  }

  set {
    name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = "alb"
  }
  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/scheme"
    value = "internal"
  }
  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/target-type"
    value = "ip"
  }
}
