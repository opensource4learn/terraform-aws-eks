######################################################################################
# EKS Cluster
######################################################################################

// AWS EKS Cluster resource definition
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.cluster_prefix}-cluster"  // Name of the EKS cluster
  role_arn = aws_iam_role.eks_cluster_role.arn  // IAM role ARN for the EKS cluster
  version  = var.kubernetes_version  // Kubernetes version for the cluster

  // VPC configuration for the cluster
  vpc_config {
    subnet_ids = var.private_subnet_ids  // Subnet IDs where EKS resources will be deployed
  }

  // Kubernetes network configuration
  kubernetes_network_config {
    service_ipv4_cidr = var.eks_cluster_service_ipv4_cidr  // CIDR block for Kubernetes service IPs
  }

  // Timeouts configuration for create, delete, and update operations
  timeouts {
    create = var.eks_cluster_create_timeout
    delete = var.eks_cluster_delete_timeout
    update = var.eks_cluster_update_timeout
  }

  // Dependencies on IAM resources and policies
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller_policy,
    aws_iam_role_policy_attachment.eks_cluster_elb_service_link_policy_attachment,

    aws_iam_role.eks_cluster_role,
    aws_iam_policy.alb_policy,
    aws_cloudwatch_log_group.eks_cluster_cloudwatch_log_group,
  ]

  // Tags for the EKS cluster resource
  tags = {
    Name        = "${var.cluster_prefix}-cluster"
    Environment = "all-environment"
  }
}

#################################################################################
# Creating Role and Policies for the cluster
#################################################################################

// IAM policy document for EKS cluster assume role policy
data "aws_iam_policy_document" "eks_cluster_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole",
    ]
  }
}

// IAM policy document for EKS cluster ELB service link role policy
data "aws_iam_policy_document" "eks_cluster_elb_service_link_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeAddresses",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:*"
    ]
    resources = ["*"]
  }
}

// IAM role for EKS cluster
resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.cluster_prefix}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role_policy.json
}

// IAM policy for EKS cluster ELB service link
resource "aws_iam_policy" "eks_cluster_elb_service_link_policy" {
  name   = "${var.cluster_prefix}-eks-cluster-elb-service-link-policy"
  policy = data.aws_iam_policy_document.eks_cluster_elb_service_link_role_policy.json
}

// IAM policy for AWS Load Balancer Controller
resource "aws_iam_policy" "alb_policy" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("${path.module}/iam_policy.json")
}

// Attachment of AWS Load Balancer Controller IAM policy to EKS cluster role
resource "aws_iam_role_policy_attachment" "alb_policy" {
  policy_arn = aws_iam_policy.alb_policy.arn
  role       = aws_iam_role.eks_cluster_role.name
}

// Attachment of AmazonEKS policies to EKS cluster role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

// Attachment of AmazonEKSVPCResourceController policy to EKS cluster role
resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

// Attachment of EKS cluster ELB service link policy to EKS cluster role
resource "aws_iam_role_policy_attachment" "eks_cluster_elb_service_link_policy_attachment" {
  policy_arn = aws_iam_policy.eks_cluster_elb_service_link_policy.arn
  role       = aws_iam_role.eks_cluster_role.name
}

#################################################################################
# Cloudwatch for the cluster
#################################################################################

// CloudWatch log group for EKS cluster
resource "aws_cloudwatch_log_group" "eks_cluster_cloudwatch_log_group" {
  count             = length(var.eks_cluster_enabled_log_types) > 0 ? 1 : 0
  name              = "/aws/eks/${var.cluster_prefix}-cluster"
  retention_in_days = var.eks_cluster_log_retention_in_days

  // Tags for the CloudWatch log group
  tags = {
    Name        = "${var.cluster_prefix}-cloudwatch"
    Environment = "all-environments"
  }
}
