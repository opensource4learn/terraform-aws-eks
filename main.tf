#######################################################
# Terraform Configuration
#######################################################

# Specify the required providers and backend for Terraform state
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    # Backend configuration for S3 will be added here
  }
}

# AWS provider configuration
provider "aws" {
  region = var.region
}

#######################################################
# VPC Module
#######################################################

# Create the VPC and subnets using a module
module "vpc" {
  source         = "./modules/vpc"
  cluster_prefix = var.cluster_prefix
  cidr           = var.cidr
  subnet_bits    = var.subnet_bits
}

#######################################################
# EKS Cluster Module
#######################################################

# Create the EKS cluster using a module
module "eks" {
  source                        = "./modules/eks"
  cluster_prefix                = var.cluster_prefix
  kubernetes_version            = var.kubernetes_version
  private_subnet_ids            = module.vpc.private_subnet_ids
  eks_cluster_enabled_log_types = var.eks_cluster_enabled_log_types
}

#######################################################
# EKS Node Groups Module
#######################################################

# Create EKS node groups using a module
module "nodes" {
  depends_on       = [module.eks]
  for_each         = var.nodes
  source           = "./modules/eks/nodes"
  cluster_prefix   = var.cluster_prefix
  node_environment = each.key
  subnet_ids       = module.vpc.private_subnet_ids
  cluster_name     = module.eks.cluster_name
  node_type        = each.value.node_type
  instance_type    = try(each.value.instance_type, null)
  desired_size     = try(each.value.desired_size, null)
  max_size         = try(each.value.max_size, null)
  min_size         = try(each.value.min_size, null)
  selector         = each.value.node_type == "fargate" ? each.value.selector : null
}

#######################################################
# RDS Database Module
#######################################################

# Create RDS instances using a module
module "database" {
  for_each          = var.databases
  source            = "./modules/rds"
  cluster_prefix    = var.cluster_prefix
  db_environment    = each.key
  db_engine         = each.value.db_engine
  db_instance_class = each.value.db_instance_class
  db_version        = each.value.db_version
  db_storage        = each.value.db_storage
  db_name           = each.value.db_name
  db_username       = each.value.db_username
  db_password       = each.value.db_password
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.storage_subnet_ids
}

##########################################################################
# ECR Module
#########################################################################

module "ecr" {
  for_each = var.ecr
  source   = "./modules/ecr"
  
  repository_name     = each.value.repositories  # Assuming 'repositories' is the correct attribute
  cluster_prefix      = var.cluster_prefix
  image_tag_mutability = "MUTABLE"  # Ensure this matches the desired mutability setting
  scan_on_push        = false       # Adjust as per your requirements
}