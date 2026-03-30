module "vpc" {
  source = "./modules/vpc"
}

module "secret" {
  source = "./modules/secrets"
  db_password = var.db_password
  jwt_secret  = var.jwt_secret
}