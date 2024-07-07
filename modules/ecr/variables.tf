###################################################################################
# Variables
###################################################################################


variable "cluster_prefix" {
  description = "Prefix for the ECR repositories"
  type        = string
}

variable "repository_name" {
  description = "The name of the ECR repository"
  type        = list(string)
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Valid values are MUTABLE and IMMUTABLE."
  type        = string
  default     = "MUTABLE"
}


variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository (true/false)."
  type        = bool
  default     = false
}