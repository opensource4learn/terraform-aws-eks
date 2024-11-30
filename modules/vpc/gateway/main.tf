#######################################################
# Internet Gateway
#######################################################

# Resource: aws_internet_gateway.this
# Description: Creates an Internet Gateway if gateway_type is "internet" to provide internet access to public subnets.
resource "aws_internet_gateway" "this" {
  count = var.gateway_type == "internet" ? 1 : 0

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.cluster_prefix}-${var.gateway_type}-gateway"
  }
}

#######################################################
# Elastic IP (EIP)
#######################################################

# Resource: aws_eip.nat
# Description: Creates an Elastic IP (EIP) if gateway_type is "nat" to associate with a NAT Gateway.
resource "aws_eip" "nat" {
  count = var.gateway_type == "nat" ? 1 : 0
  
  tags = {
    Name = "${var.cluster_prefix}-eip"
  }
}

#######################################################
# NAT Gateway
#######################################################

# Resource: aws_nat_gateway.this
# Description: Creates a NAT Gateway if gateway_type is "nat" to allow private subnet instances to access the internet.
resource "aws_nat_gateway" "this" {
  count = var.gateway_type == "nat" ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = var.subnet_id

  tags = {
    Name = "${var.cluster_prefix}-nat-gateway"
  }
}
