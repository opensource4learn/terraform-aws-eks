#######################################################
# Outputs
#######################################################

# EKS cluster endpoint
output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

# AWS region
output "region" {
  description = "AWS region"
  value       = var.region
}

# EKS cluster name
output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

# RDS endpoints
output "rds_endpoints" {
  description = "RDS Endpoints"
  value       = { for key, db in module.database : key => db.db_instance_endpoint }
}

# Public subnets IDs
output "public_subnets" {
  description = "IDs of public subnets"
  value       = module.vpc.public_subnets_ids
}

# VPC ID
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

# ECR Output

# output "ecr_url" {
#   description = "ECR urls" 
#   value = module.ecr.ecr_repository_urls
# }