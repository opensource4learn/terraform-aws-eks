#######################################################
# Subnets
#######################################################

#Data Source: AWS Availability Zones
# Fetches a list of all available availability zones in the current region
data "aws_availability_zones" "available_zones" {}

# Local Variables
locals {
  # Offset calculation based on the number of available availability zones
  offset = length(data.aws_availability_zones.available_zones.names)
}

# Resource: AWS Subnet
# Creates subnets across all available availability zones
resource "aws_subnet" "subnet" {
  count = length(data.aws_availability_zones.available_zones.names)
  
  # CIDR block calculation for the subnet
  cidr_block = cidrsubnet(var.cidr, var.subnet_bits, local.offset * var.offset + count.index)
  
  # VPC ID in which the subnet will be created
  vpc_id = var.vpc_id
  
  # Assigns the subnet to a specific availability zone
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  
  # Tags assigned to the subnet for identification
  tags = {
    Name = "${var.cluster_prefix}-${lower(var.subnet_type)}-subnet-${count.index + 1}"
  }
}
