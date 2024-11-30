#######################################################
# Variables
#######################################################

# Variable: cluster_prefix
# Description: Prefix to apply generic naming to resources like VPC and subnets
variable "cluster_prefix" {
  type        = string
  description = "Prefix to apply generic naming to resources like VPC and subnets"
}

# Variable: cidr
# Description: CIDR block for the VPC
variable "cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

# Variable: subnet_bits
# Description: Number of bits to use for subnet calculations
variable "subnet_bits" {
  type        = string
  description = "Number of bits to use for subnet calculations"
}
