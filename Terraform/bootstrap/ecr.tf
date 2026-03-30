locals {
  services = {
    "api-gateway" = { name = "api-gateway" }
    "order-service" = { name = "order-service" } 
    "inventory-service" = { name = "inventory-service" }
    "payment-service" = { name = "payment-service" }
    "notification-service" = { name  ="notification-service" }
    "shipping-service" = { name = "shipping-service" }
    "worker" = { name = "worker" }
    "scheduler" = { name = "scheduler" }
    "dashboard-api" = { name = "dashboard-api" }
  }

  name = "ECSv3"
}

resource "aws_ecr_repository" "ecs-project-v3" {
  for_each = local.services
  name = each.key
  image_tag_mutability = "MUTABLE"
  force_delete = true
  
  image_scanning_configuration {
    scan_on_push = true
  }

}

resource "aws_ecr_lifecycle_policy" "main" {
  for_each = local.services
  repository = aws_ecr_repository.ecs-project-v3[each.key].name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire untagged images older than 3 day",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 3
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "rulePriority": 2,
      "description": "Keep last 10 images",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["v"],
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "rulePriority": 3,
      "description": "Archive images older than 30 days",
      "selection": {
        "tagStatus": "any",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 30
      },
      "action": {
        "type": "transition",
        "targetStorageClass": "archive"
      }
    },
    {
      "rulePriority": 4,
      "description": "Delete images archived for more than 365 days",
      "selection": {
        "tagStatus": "any",
        "storageClass": "archive",
        "countType": "sinceImageTransitioned",
        "countUnit": "days",
        "countNumber": 365
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}