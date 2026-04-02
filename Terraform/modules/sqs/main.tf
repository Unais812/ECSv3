# DLQ is where messages go after failing
resource "aws_sqs_queue" "dlq" {
  name                      = "ecs-v3-dlq"
  message_retention_seconds = 432000  # 5 days
}

resource "aws_sqs_queue" "main" {
  name                       = "ecs-v3-main-sqs"
  visibility_timeout_seconds = 30  # how long a message is hidden after being picked up

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 3  # fail 3 times → goes to DLQ
  })
}