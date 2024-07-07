##############################################################################
# Outputs
#############################################################################

# Output: Database Instance Endpoint
# The endpoint address of the RDS instance
output "db_instance_endpoint" {
  description = "The endpoint address of the RDS instance"
  value       = aws_db_instance.db_instance.endpoint
}

# Output: Database Instance ID
# The unique identifier of the RDS instance
output "db_instance_id" {
  description = "The unique identifier of the RDS instance"
  value       = aws_db_instance.db_instance.id
}

# Output: RDS Security Group ID
# The ID of the security group associated with the RDS instance
output "rds_security_group_id" {
  description = "The ID of the security group associated with the RDS instance"
  value       = aws_security_group.rds_sg.id
}
