terraform {
backend "s3" {
    region  = "us-east-1"
    bucket  = "aws-eks-28feb2022"
    key     = "dev/us-east-1/terraform.tfstate"
}
}