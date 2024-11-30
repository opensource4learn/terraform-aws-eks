######################################################################################
# Outputs for the KS Modules
######################################################################################


// Output: Cluster Endpoint
output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

// Output: Cluster Name
output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = aws_eks_cluster.eks_cluster.name
}
