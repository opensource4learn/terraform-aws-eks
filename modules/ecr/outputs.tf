###################################################################################
# Output Configuration
###################################################################################

output "ecr_repository_urls" {
  value = { for repo, details in aws_ecr_repository.ecr : repo => details.repository_url }
}

output "repository_names" {
  description = "The names of the repositories"
  value       = { for key, _ in aws_ecr_repository.ecr : key => aws_ecr_repository.ecr[key].name }
}