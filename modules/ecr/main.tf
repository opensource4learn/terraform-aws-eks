###################################################################################
# Ecr Configuration
###################################################################################

resource "aws_ecr_repository" "ecr" {
  for_each = { for repo in var.repository_name : repo => repo }

  name                 = "${var.cluster_prefix}-${each.key}"
  image_tag_mutability = var.image_tag_mutability
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}


# resource "aws_ecr_lifecycle_policy" "this" {
#   repository = aws_ecr_repository.ecr.name
#   policy     = var.lifecycle_policy
# }
