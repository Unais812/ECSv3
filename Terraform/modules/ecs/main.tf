resource "aws_ecs_cluster" "ecs-v3-cluster" {
  name = "${local.name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}


resource "aws_cloudwatch_log_group" "cw_log_group" {
  name              = var.log_group_name
  retention_in_days = var.log_days
}

resource "aws_ecs_task_definition" "api-gateway-task" {
  family = local.name
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  execution_role_arn = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = local.name
      image     = var.image
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.host_port
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"       = aws_cloudwatch_log_group.cw_log_group.name
          awslogs-region        = var.region
          awslogs-stream-prefix = var.logstream_prefix

        }
       }
    },
  ])

  tags = {
    Name = "${local.name}-task"
  }
}

resource "aws_ecs_service" "api-gateway-service" {
  name            = "${local.name}-service"
  cluster         = aws_ecs_cluster.ecs-v3-cluster.id
  task_definition = aws_ecs_task_definition.api-gateway-task.arn
  desired_count   = 1

  ordered_placement_strategy {
    type  = "random"
  }

  load_balancer {
    target_group_arn = var.api_gateway_target_group
    container_name   = "latest"
    container_port   = var.container_port
  }
}