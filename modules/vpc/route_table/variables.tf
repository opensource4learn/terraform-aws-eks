#######################################################
# Variablesw
#######################################################

# Variable Definitions

# The ID of the VPC
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

# The ID of the Internet Gateway (required if route table type is public)
variable "internet_gateway_id" {
  description = "The ID of the Internet Gateway (required if public)"
  type        = string
  default     = null
}

# The ID of the NAT Gateway (required if route table type is private)
variable "nat_gateway_id" {
  description = "The ID of the NAT Gateway (required if private)"
  type        = string
  default     = null
}

# Prefix for naming resources
variable "cluster_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

# Type of route table: public or private
variable "route_table_type" {
  description = "Type of route table: public or private"
  type        = string
  validation {
    condition     = contains(["public", "private"], var.route_table_type)
    error_message = "route_table_type must be either 'public' or 'private'."
  }
}

# List of subnet IDs to associate with the route table
variable "subnet_ids" {
  description = "List of subnet IDs to associate with the route table"
  type        = list(string)
}
