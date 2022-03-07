# create all Subdomains required by Kubernetes Deployments
resource "aws_route53_record" "deployments_subdomains" {
  for_each = toset(var.deployments_subdomains)

  zone_id = aws_route53_zone.primary.id
  name    = "${each.key}.${aws_route53_record.eks_domain.fqdn}"
  type    = "CNAME"
  ttl     = "5"
  records = ["${data.kubernetes_service.ingress_gateway.load_balancer_ingress.0.hostname}"]
}