# Terraform variables for configuring the infrastructure

# To apply generic naming to EKS Cluster
cluster_prefix = "source4learn"

# AWS Region for the infrastructure
region = "ap-southeast-2"

# CIDR block for the VPC
cidr = "10.0.0.0/16"

# Number of subnet bits
subnet_bits = 4

# Kubernetes version for EKS Cluster
kubernetes_version = "1.28"

# List of Control Plane Logging options to enable
eks_cluster_enabled_log_types = ["api", "audit"]

# Cloudwatch log events retention period in days for EKS Cluster
eks_cluster_log_retention_in_days = 7

# EKS Cluster - Kubernetes Service IP address range
eks_cluster_service_ipv4_cidr = "10.43.0.0/16"

# Average wait time in minutes for the EKS Cluster to be created
eks_cluster_create_timeout = "30m"

# Average wait time in minutes for the EKS Cluster to be deleted
eks_cluster_delete_timeout = "15m"

# Average wait time in minutes for the EKS Cluster to be updated
eks_cluster_update_timeout = "60m"

# Map of node groups to create with their respective configurations
nodes= {
  dev = {
    instance_type   = ["t3.medium"]
    node_type = "vm"
    desired_size    = 3
    max_size        = 4
    min_size        = 1
  }
  prod = {
    node_type = "fargate"
    selector        = ["production"]
  }
}

# Map of databases to create with their respective configurations
databases = {
  dev = {
    db_engine         = "postgres"
    db_instance_class = "db.t3.micro"
    db_version        = "13.13"
    db_storage        = 20
    db_name           = "devapi2"
    db_username       = "devapi2admin"
    db_password       = ""
  }
}


# ECR configuration

ecr = {
  dev = {
    repositories = [
      "test1"
    ]
  }
  prod = {
    repositories = [
      "test2"
    ]
  }
}