module "vpc" {
  source = "./modules/vpc"
  vpc_endpoint_sg = module.security-groups.vpc_endpoint_sg
}

module "ecs-cluster" {
  source = "./modules/ecs-cluster"
}

module "ecs-api-gatewway" {
  source = "./modules/ecs-api-gateway"
  execution_role_arn = module.iam.execution_role_arn
  api_gateway_target_group = module.alb.api_gateway_target_group
  ecs_sg = module.security-groups.ecs_sg
  private_subnet_ids = module.vpc.private_subnet_ids
  ecs_cluster_id = module.ecs-cluster.ecs_cluster_id
  jwt_secret_arn = module.secrets.jwt_secret_arn
}

module "ecs-dashboard-api" {
  source = "./modules/ecs-dashboard-api"
  private_subnet_ids = module.vpc.private_subnet_ids
  ecs_cluster_id = module.ecs-cluster.ecs_cluster_id
  execution_role_arn = module.iam.execution_role_arn
  ecs_sg = module.security-groups.ecs_sg
  database_url_secret_arn = module.secrets.database_url_arn
  service_discovery_arn = module.vpc.service_discovery_arns["dashboard-api"]
}

module "ecs-inventory-service" {
  source = "./modules/ecs-inventory-service"
  database_url_secret_arn = module.secrets.database_url_arn
  private_subnet_ids = module.vpc.private_subnet_ids
  ecs_cluster_id = module.ecs-cluster.ecs_cluster_id
  execution_role_arn = module.iam.execution_role_arn
  ecs_sg = module.security-groups.ecs_sg
  service_discovery_arn = module.vpc.service_discovery_arns["inventory-service"]
}

module "notification-service" {
  source = "./modules/ecs-notification-service"
  database_url_secret_arn = module.secrets.database_url_arn
  private_subnet_ids = module.vpc.private_subnet_ids
  ecs_cluster_id = module.ecs-cluster.ecs_cluster_id
  execution_role_arn = module.iam.execution_role_arn
  ecs_sg = module.security-groups.ecs_sg
  service_discovery_arn = module.vpc.service_discovery_arns["notification-service"]
}

module "order-service" {
  source = "./modules/ecs-order-service"
  database_url_secret_arn = module.secrets.database_url_arn
  private_subnet_ids = module.vpc.private_subnet_ids
  ecs_cluster_id = module.ecs-cluster.ecs_cluster_id
  execution_role_arn = module.iam.execution_role_arn
  ecs_sg = module.security-groups.ecs_sg
  service_discovery_arn = module.vpc.service_discovery_arns["order-service"]
  task_role_arn = module.iam.order_service_task_role_arn
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  ecs_sg_alb = module.security-groups.ecs_sg_alb
}

module "security-groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "./modules/iam"
  sqs_queue_arn = module.sqs.queue_arn
}

module "database" {
  source = "./modules/database"
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg = module.security-groups.rds_sg
  db_password = var.db_password
}

module "secrets" {
  source = "./modules/secrets"
  rds_endpoint = module.database.rds_endpoint
  db_password = var.db_password
  jwt_secret = var.jwt_secret
}

module "sqs" {
  source = "./modules/sqs"
}