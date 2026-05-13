output "api_gateway_target_group" {
  value = aws_lb_target_group.api-gateway.arn
}

output "dashboard_api_target_group" {
  value = aws_lb_target_group.dashboard-api.arn
}

output "alb_dns" {
  value = aws_lb.ecs-v3-alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.ecs-v3-alb.zone_id
}