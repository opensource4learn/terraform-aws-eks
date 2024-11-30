#######################################################
# Subnets
#######################################################

# Output: Subnet IDs
# Provides the IDs of the subnets created
output "subnet_ids" {
  description = "The IDs of the created subnets"
  value       = aws_subnet.subnet[*].id
}
