#################################################################################
# VM Node Group
#################################################################################

// AWS EKS Node Group resource
resource "aws_eks_node_group" "node_group" {
  count           = var.node_type == "vm" ? 1 : 0  // Conditional creation based on node_type
  cluster_name    = var.cluster_name                      // Name of the EKS cluster
  node_group_name = "${var.cluster_prefix}-${var.node_environment}-node-group"  // Name of the node group
  node_role_arn   = aws_iam_role.vm_node_group[0].arn     // IAM role ARN for the node group
  subnet_ids      = var.subnet_ids                        // Subnet IDs for the node group instances
  instance_types  = var.instance_type                    // Instance types for the node group
  disk_size       = var.disk_size                         // Disk size for the node group instances

  // Scaling configuration for the node group
  scaling_config {
    desired_size = var.desired_size  // Desired number of instances
    max_size     = var.max_size      // Maximum number of instances
    min_size     = var.min_size      // Minimum number of instances
  }

  // Lifecycle configuration to ignore changes in desired_size
  # lifecycle {
  #   ignore_changes = [scaling_config[0].desired_size]
  # }

  // Update configuration for the node group
  update_config {
    max_unavailable = 1  // Maximum number of unavailable instances during updates
  }

  // Dependencies on IAM role policies before creating the node group
  depends_on = [
    aws_iam_role.vm_node_group,
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy[0],
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy[0],
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly[0],
  ]
}

// IAM role for VM Node Group
resource "aws_iam_role" "vm_node_group" {
  count = var.node_type == "vm" ? 1 : 0  // Conditional creation based on node_type
  name  = "${var.cluster_prefix}-${var.node_environment}-vm-role"  // Name of the IAM role

  // Assume role policy allowing EC2 instances to assume this role
  assume_role_policy = jsonencode({
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

// IAM role policy attachment for AmazonEKSWorkerNodePolicy
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  count      = var.node_type == "vm" ? 1 : 0  // Conditional creation based on node_type
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"  // ARN of the policy
  role       = aws_iam_role.vm_node_group[0].name   // Name of the IAM role to attach the policy to
}

// IAM role policy attachment for AmazonEKS_CNI_Policy
resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  count      = var.node_type == "vm" ? 1 : 0  // Conditional creation based on node_type
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"  // ARN of the policy
  role       = aws_iam_role.vm_node_group[0].name   // Name of the IAM role to attach the policy to
}

// IAM role policy attachment for AmazonEC2ContainerRegistryReadOnly
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  count      = var.node_type == "vm" ? 1 : 0  // Conditional creation based on node_type
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"  // ARN of the policy
  role       = aws_iam_role.vm_node_group[0].name   // Name of the IAM role to attach the policy to
}

#################################################################################
# Fargate Profile
#################################################################################

// AWS EKS Fargate Profile resource
resource "aws_eks_fargate_profile" "fargate" {
  count                = var.node_type == "fargate" ? 1 : 0  // Conditional creation based on node_type
  cluster_name         = var.cluster_name                            // Name of the EKS cluster
  fargate_profile_name = "${var.cluster_prefix}-${var.node_environment}-fargate-profile"  // Name of the Fargate profile
  pod_execution_role_arn = aws_iam_role.fargate_iam[0].arn           // IAM role ARN for Fargate pods
  subnet_ids           = var.subnet_ids                              // Subnet IDs for Fargate

  // Dynamic selector for Fargate profile
  dynamic "selector" {
    for_each = var.selector != null && length(var.selector) > 0 ? toset(var.selector) : []  // Selectors for namespaces
    content {
      namespace = selector.value  // Namespace selector
    }
  }
}

// IAM role for Fargate pods
resource "aws_iam_role" "fargate_iam" {
  count = var.node_type == "fargate" ? 1 : 0  // Conditional creation based on node_type
  name  = "${var.cluster_prefix}-${var.node_environment}-fargate-role"  // Name of the IAM role

  // Assume role policy allowing EKS Fargate pods to assume this role
  assume_role_policy = jsonencode({
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

// IAM role policy attachment for AmazonEKSFargatePodExecutionRolePolicy
resource "aws_iam_role_policy_attachment" "AmazonEKSFargatePodExecutionRolePolicy" {
  count      = var.node_type == "fargate" ? 1 : 0  // Conditional creation based on node_type
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"  // ARN of the policy
  role       = aws_iam_role.fargate_iam[0].name   // Name of the IAM role to attach the policy to
}
