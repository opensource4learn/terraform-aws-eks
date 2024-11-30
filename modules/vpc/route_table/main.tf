#######################################################
# Route Tables
#######################################################

# Resource: aws_route_table
# Description: Manages a route table for a VPC.
resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  # Dynamic Block: route (Public Route)
  # Description: Defines a route for the public subnet(s) to route traffic via an Internet Gateway.
  dynamic "route" {
    for_each = var.route_table_type == "public" ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = var.internet_gateway_id
    }
  }

  # Dynamic Block: route (Private Route)
  # Description: Defines a route for the private subnet(s) to route traffic via a NAT Gateway.
  dynamic "route" {
    for_each = var.route_table_type == "private" ? [1] : []
    content {
      cidr_block   = "0.0.0.0/0"
      nat_gateway_id = var.nat_gateway_id
    }
  }

  # Tags: Name
  # Description: Tags the route table with a name based on the cluster prefix and route table type.
  tags = {
    Name = "${var.cluster_prefix}-${var.route_table_type}-rt"
  }
}

# Resource: aws_route_table_association
# Description: Associates subnet(s) with the specified route table.
resource "aws_route_table_association" "this" {
  count          = length(var.subnet_ids)
  subnet_id      = element(var.subnet_ids, count.index)
  route_table_id = aws_route_table.this.id
}
