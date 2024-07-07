##############################################################################
# Outputs
#############################################################################

# Variable Definitions

# Prefix for naming resources
variable "cluster_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

# Storage size for the database
variable "db_storage" {
  description = "Allocated storage size for the RDS instance in GB"
  type        = number
}

# Environment for the database (e.g., dev, prod)
variable "db_environment" {
  description = "Environment for the database (e.g., dev, prod)"
  type        = string
}

# Database engine type (e.g., postgres, mysql)
variable "db_engine" {
  description = "Type of the database engine (e.g., postgres, mysql)"
  type        = string
}

# Instance class for the database
variable "db_instance_class" {
  description = "Instance class for the RDS database instance"
  type        = string
}

# Port for the database
variable "db_port" {
  description = "Port number on which the database accepts connections. Defaults to 5432 for PostgreSQL"
  type        = string
  default     = "5432"
}

# Allowed IP addresses for database access
variable "allowed_ip" {
  description = "List of allowed IP addresses for database access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Version of the database engine
variable "db_version" {
  description = "Version of the database engine"
  type        = string
}

# Name of the database
variable "db_name" {
  description = "Name of the database"
  type        = string
}

# Username for the database
variable "db_username" {
  description = "Username for the database"
  type        = string
}

# Password for the database
variable "db_password" {
  description = "Password for the database"
  type        = string
}

# List of subnet IDs for the database
variable "subnet_ids" {
  description = "List of subnet IDs for the RDS instance"
  type        = list(string)
}

# ID of the VPC
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}
