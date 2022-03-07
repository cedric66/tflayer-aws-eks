module "eks_cluster" {
  source = "../modules/eks"

  #vpc
  iac_environment_tag = var.iac_environment_tag
  name_prefix = var.name_prefix
  main_network_block = var.main_network_block
  subnet_prefix_extension = var.subnet_prefix_extension
  zone_offset = var.zone_offset
  #eks
  region = var.region
  cluster_name  = var.cluster_name
  admin_users = var.admin_users
  developer_users = var.developer_users
  asg_instance_types = var.asg_instance_types
  autoscaling_minimum_size_by_az = var.autoscaling_minimum_size_by_az
  autoscaling_maximum_size_by_az = var.autoscaling_maximum_size_by_az
  autoscaling_average_cpu = var.autoscaling_average_cpu
  spot_termination_handler_chart_name = var.spot_termination_handler_chart_name
  spot_termination_handler_chart_repo = var.spot_termination_handler_chart_repo
  spot_termination_handler_chart_version = var.spot_termination_handler_chart_version
  spot_termination_handler_chart_namespace = var.spot_termination_handler_chart_namespace

  #ingress

  dns_base_domain = var.dns_base_domain
  ingress_gateway_chart_name = var.ingress_gateway_chart_name
  ingress_gateway_chart_repo = var.ingress_gateway_chart_repo
  ingress_gateway_chart_version = var.ingress_gateway_chart_version
  ingress_gateway_annotations = var.ingress_gateway_annotations

  #subdomain
  deployments_subdomains = var.deployments_subdomains

  #namespaces
  namespaces = var.namespaces

  #grafana
  grafana_password = var.grafana_password
}