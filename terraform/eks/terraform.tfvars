region = "us-east-1"

#network
cluster_name            = "my-app-eks"
iac_environment_tag     = "development"
name_prefix             = "dev-app"
main_network_block      = "10.0.0.0/16"
subnet_prefix_extension = 4
zone_offset             = 8

#EKS
admin_users                              = ["admin1", "admin2"]
developer_users                          = ["user1", "user2"]
asg_instance_types                       = ["t3.small", "t2.small"]
autoscaling_minimum_size_by_az           = 1
autoscaling_maximum_size_by_az           = 5
autoscaling_average_cpu                  = 30
spot_termination_handler_chart_name      = "aws-node-termination-handler"
spot_termination_handler_chart_repo      = "https://aws.github.io/eks-charts"
spot_termination_handler_chart_version   = "0.9.1"
spot_termination_handler_chart_namespace = "kube-system"