data "template_file" "mysql_values" {
	template = file("../modules/templates/mysql-values.yml")

  	vars = {
	  NAMESPACE = "dev"
	}
}

resource "helm_release" "mysql" {
  name       = "mysql"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mysql"
  version    = "8.2.3"

  values = [
    data.template_file.mysql_values.rendered
  ]

  set {
    name  = "metrics.enabled"
    value = "true"
  }

  set {
    name  = "service.annotations.prometheus.io/port" 
    value = "9127"
    type  = "string"
  }
}