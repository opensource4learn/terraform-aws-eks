#######################################################
# Variables
#######################################################

# Variable: cluster_prefix
# Description: Prefix to apply generic naming to resources like VPC and subnets
variable "cluster_prefix" {
  type = string
}

# Variable: vpc_id
# Description: The ID of the VPC where the gateway will be attached
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

# Variable: gateway_type
# Description: Type of gateway to create: 'nat' for NAT Gateway or 'internet' for Internet Gateway
variable "gateway_type" {
  description = "Type of gateway: nat or internet"
  type        = string
  validation {
    condition     = contains(["nat", "internet"], var.gateway_type)
    error_message = "gateway_type must be either 'nat' or 'internet'."
  }
}

# Variable: subnet_id
# Description: The ID of the subnet in which to place the NAT Gateway (required if gateway_type is 'nat')
variable "subnet_id" {
  description = "The ID of the subnet in which to place the NAT Gateway (required if NAT Gateway)"
  type        = string
  default     = null
}

# Variable: tags
# Description: Tags to assign to the gateway
variable "tags" {
  description = "Tags to assign to the gateway"
  type        = map(string)
  default     = {}
}
