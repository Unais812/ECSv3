resource "aws_ecs_cluster" "ecs-v3-cluster" {
  name = "evs-v3-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}