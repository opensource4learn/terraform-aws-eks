#######################################################
# Variables
#######################################################

# Variable: cidr
# Description: The CIDR block of the VPC.
variable "cidr" {
  description = "The CIDR block of the VPC"
  type        = string
}

# Variable: subnet_bits
# Description: The number of bits for the subnet.
variable "subnet_bits" {
  description = "The number of bits for subnet"
  type        = number
}

# Variable: vpc_id
# Description: The ID of the VPC.
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

# Variable: cluster_prefix
# Description: Prefix for the cluster, used for naming resources.
variable "cluster_prefix" {
  description = "Prefix for the cluster"
  type        = string
}

# Variable: subnet_type
# Description: Type of subnet (e.g., public, private, storage).
variable "subnet_type" {
  description = "Type of subnet"
  type        = string
}

# Variable: offset
# Description: Offset value used for calculating subnet CIDR blocks.
variable "offset" {
  description = "Offset value for subnet calculation"
  type        = number
}
