data "template_file" "grafana_values" {
	template = file("../modules/templates/grafana-values.yml")

  	vars = {
      GRAFANA_SERVICE_ACCOUNT = "grafana"
	  GRAFANA_ADMIN_USER = "admin"
	  GRAFANA_ADMIN_PASSWORD = var.grafana_password
	  PROMETHEUS_SVC = "${helm_release.prometheus.name}-server"
	  NAMESPACE = "dev"
	}
}

resource "helm_release" "grafana" {
  chart = "grafana"
  name = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  namespace = "dev"

  values = [
  	data.template_file.grafana_values.rendered
  ]
}