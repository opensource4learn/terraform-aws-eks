#######################################################
# Outputs
#######################################################

# Output: VPC ID
# The ID of the created VPC
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.vpc.id
}

# Output: Public Subnet IDs
# List of IDs of the created public subnets
output "public_subnets_ids" {
  description = "List of IDs of the created public subnets"
  value       = module.public_subnets.subnet_ids
}

# Output: Private Subnet IDs
# List of IDs of the created private subnets
output "private_subnet_ids" {
  description = "List of IDs of the created private subnets"
  value       = module.private_subnets.subnet_ids
}

# Output: Storage Subnet IDs
# List of IDs of the created storage subnets
output "storage_subnet_ids" {
  description = "List of IDs of the created storage subnets"
  value       = module.storage_subnets.subnet_ids
}

# Output: Internet Gateway ID
# The ID of the created Internet Gateway
output "internet_gateway_id" {
  description = "The ID of the created Internet Gateway"
  value       = module.internet_gateway.internet_gateway_id
}
