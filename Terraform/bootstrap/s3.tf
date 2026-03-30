resource "aws_s3_bucket" "ecs-project-v3-s3" {
  bucket = "ecs-project-v3-s3"
  force_destroy = true
  
  tags = {
    Name        = "ecs-project-v3-s3"
  }
}

resource "aws_s3_bucket_versioning" "ecs-project-v3-versioning" {
  bucket = aws_s3_bucket.ecs-project-v3-s3.id
  versioning_configuration {
    status = "Enabled"
  }
}