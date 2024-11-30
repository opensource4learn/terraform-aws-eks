#################################################################################
# Variables
#################################################################################


// Prefix used in naming resources within the EKS cluster
variable "cluster_prefix" {
  type = string
}

// Name of the EKS cluster
variable "cluster_name" {
  type = string
}

// List of subnet IDs where EKS resources (nodes or Fargate profiles) will be deployed
variable "subnet_ids" {
  type = list(string)
}

// Desired number of instances in the node group (default: 1)
variable "desired_size" {
  type    = number
  default = 1
}

// Maximum number of instances in the node group (default: 1)
variable "max_size" {
  type    = number
  default = 1
}

// Minimum number of instances in the node group (default: 1)
variable "min_size" {
  type    = number
  default = 1
}

// List of instance types for nodes in the node group (default: ["t3.medium"])
variable "instance_type" {
  type    = list(string)
  default = ["t3.medium"]
}

// Environment identifier used in naming resources within the cluster
variable "node_environment" {
  type = string
}

// Size of the disk attached to each instance in the node group (default: "30" GB)
variable "disk_size" {
  type    = string
  default = "30"
}

// Type of the node group to create. Possible values are 'fargate' or 'vm'.
variable "node_type" {
  description = "Type of the node group to create. Possible values are 'fargate' or 'vm'."
  type        = string
  default     = "vm"
}

// List of namespaces for Fargate profile selectors (optional)
variable "selector" {
  description = "List of namespaces for Fargate profile selectors."
  type        = list(string)
}
