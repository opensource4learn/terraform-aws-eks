#######################################################
# Terraform Variables
#######################################################
# Terraform Variables

# To apply generic naming to EKS Cluster
variable "cluster_prefix" {
  description = "Prefix to apply to EKS Cluster"
  type        = string
  default     = "source4learn"
}

# AWS Region for the infrastructure
variable "region" {
  description = "AWS Region where the infrastructure will be deployed"
  type        = string
}

# CIDR block for the VPC
variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

# Number of subnet bits for subnet calculation
variable "subnet_bits" {
  description = "Number of bits to use for subnetting"
  type        = number
}

# Kubernetes version for EKS Cluster
variable "kubernetes_version" {
  description = "Version of Kubernetes for the EKS Cluster"
  type        = string
  default     = "1.19"
}

# List of Control Plane Logging options to enable
variable "eks_cluster_enabled_log_types" {
  description = "List of Control Plane Logging options to enable"
  type        = list(any)
  default     = ["api", "audit"]
}

# Cloudwatch log events retention period in days for EKS Cluster
variable "eks_cluster_log_retention_in_days" {
  description = "Retention period in days for CloudWatch log events"
  type        = number
  default     = 7
}

# EKS Cluster - Kubernetes Service IP address range
variable "eks_cluster_service_ipv4_cidr" {
  description = "IP address range for Kubernetes services in the EKS Cluster"
  type        = string
  default     = "10.43.0.0/16"
}

# Average wait time in minutes for the EKS Cluster to be created
variable "eks_cluster_create_timeout" {
  description = "Average wait time in minutes for EKS Cluster creation"
  type        = string
  default     = "30m"
}

# Average wait time in minutes for the EKS Cluster to be deleted
variable "eks_cluster_delete_timeout" {
  description = "Average wait time in minutes for EKS Cluster deletion"
  type        = string
  default     = "15m"
}

# Average wait time in minutes for the EKS Cluster to be updated
variable "eks_cluster_update_timeout" {
  description = "Average wait time in minutes for EKS Cluster update"
  type        = string
  default     = "60m"
}

# Map of node groups to create with their respective configurations
variable "nodes" {
  description = "Map of node groups to create with their respective configurations"
  type = map(object({
    instance_type = optional(list(string))
    node_type     = string
    desired_size  = optional(number)
    max_size      = optional(number)
    min_size      = optional(number)
    selector      = optional(list(string))
  }))
}

# Map of databases to create with their respective configurations
variable "databases" {
  description = "Map of databases to create with their respective configurations"
  type = map(object({
    db_name = string
    db_password = string
    db_username = string
    db_engine         = string
    db_instance_class = string
    db_version        = string
    db_storage        = number
  }))
}


# ECR variable
variable "ecr" {
  type = map(object({
    repositories = list(string)
  }))

}