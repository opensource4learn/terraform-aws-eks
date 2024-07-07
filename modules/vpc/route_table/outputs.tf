#######################################################
# Outputs
#######################################################

# Output: route_table_id
# Description: Provides the ID of the created route table.
output "route_table_id" {
  description = "The ID of the route table"
  value       = aws_route_table.this.id
}
