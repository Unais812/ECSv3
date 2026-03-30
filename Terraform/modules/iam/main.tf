resource "aws_iam_role" "ecs_execution_iam_role" {
  name = "ecs_execution_iam_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secrets_policy_attachment" {
  role       = aws_iam_role.ecs_execution_iam_role.name
  policy_arn = var.secrets_policy_arn
}

resource "aws_iam_role_policy_attachment" "task_execution_policy_attachment" {
  role = aws_iam_role.ecs_execution_iam_role.name
  policy_arn = var.task_execution_policy_arn
}



