output "ecs_sg" {
  value = aws_security_group.ecs_sg.id
}

output "ecs_sg_alb" {
  value = aws_security_group.ecs_sg_alb.id
}