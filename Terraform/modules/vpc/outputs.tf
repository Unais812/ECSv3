output "vpc_id" {
  value = aws_vpc.ecs-v3.id
}

output "private_subnet_ids" {
  value = [
    for k, subnet in aws_subnet.subnets :
    subnet.id
    if !local.subnets[k].public
  ]
}

# loops through the locals block and determines wether it is a private subnet or public,
# it also outputs the id for them so i can reference in another module 

output "public_subnet_ids" {
  value = [
    for k, subnet in aws_subnet.subnets :
    subnet.id
    if local.subnets[k].public
  ]
}

output "service_discovery_arns" {
  value = {
    for name, service in aws_service_discovery_service.ecs_tasks_dns_discovery :
    name => service.arn
  }
}