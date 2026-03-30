locals {
    name = "api-gateway"
}

locals {
  subnets = {
    "public-1"  = { cidr = "10.0.1.0/24", az = "eu-north-1a", public = true  }
    "public-2"  = { cidr = "10.0.2.0/24", az = "eu-north-1b", public = true  }
    "private-1" = { cidr = "10.0.3.0/24", az = "eu-north-1a", public = false }
    "private-2" = { cidr = "10.0.4.0/24", az = "eu-north-1b", public = false }
    "private-3" = { cidr = "10.0.5.0/24", az = "eu-north-1c", public = false }
    "public-3" = { cidr = "10.0.6.0/24", az = "eu-north-1c", public = true }
  }
}

# loops through the locals block above and determines wether it is a private subnet, 
# i can then reference the private subnets like "locals.private_subnet_ids" for ecs service 
locals {
  private_subnet_ids = [
    for k, subnet in aws_subnet.subnets :
    subnet.id
    if local.subnets[k].public == false
  ]
}