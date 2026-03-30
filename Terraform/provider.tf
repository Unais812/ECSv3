terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.28.0"
    }
  }

  backend "s3" {
    bucket       = "ecs-project-v3-s3"
    key          = "terraform.tfstate"
    region       = "eu-north-1"
    use_lockfile = true
    encrypt = true
  }
}

provider "aws" {
  region = "eu-north-1"
}