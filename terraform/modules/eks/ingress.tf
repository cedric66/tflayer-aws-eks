# create AWS-issued SSL certificate
resource "aws_acm_certificate" "eks_domain_cert" {
  domain_name               = var.dns_base_domain
  subject_alternative_names = ["*.${var.dns_base_domain}"]
  validation_method         = "DNS"

  tags = {
    Name            = "${var.dns_base_domain}"
    iac_environment = var.iac_environment_tag
  }
}
resource "aws_route53_record" "eks_domain_cert_validation_dns" {
  name    = tolist(aws_acm_certificate.eks_domain_cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.eks_domain_cert.domain_validation_options)[0].resource_record_type
  zone_id = aws_route53_zone.primary.id
  records = [tolist(aws_acm_certificate.eks_domain_cert.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}
resource "aws_acm_certificate_validation" "eks_domain_cert_validation" {
  certificate_arn         = aws_acm_certificate.eks_domain_cert.arn
  validation_record_fqdns = [aws_route53_record.eks_domain_cert_validation_dns.fqdn]
}

# deploy Ingress Controller
resource "helm_release" "ingress_gateway" {
  name       = var.ingress_gateway_chart_name
  chart      = var.ingress_gateway_chart_name
  repository = var.ingress_gateway_chart_repo
  version    = var.ingress_gateway_chart_version

  dynamic "set" {
    for_each = var.ingress_gateway_annotations

    content {
      name  = set.key
      value = set.value
      type  = "string"
    }
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = aws_acm_certificate.eks_domain_cert.id
  }
}

# create base domain for EKS Cluster
data "kubernetes_service" "ingress_gateway" {
  metadata {
    name = join("-", [helm_release.ingress_gateway.chart, helm_release.ingress_gateway.name])
  }
  
  depends_on = [module.eks-cluster]
}
data "aws_elb_hosted_zone_id" "elb_zone_id" {}
resource "aws_route53_record" "eks_domain" {
  zone_id = aws_route53_zone.primary.id
  name    = var.dns_base_domain
  type    = "A"

  alias {
    name                   = data.kubernetes_service.ingress_gateway.load_balancer_ingress.0.hostname
    zone_id                = data.aws_elb_hosted_zone_id.elb_zone_id.id
    evaluate_target_health = true
  }
}