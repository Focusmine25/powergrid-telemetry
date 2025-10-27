terraform {
  required_version = ">= 1.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">= 2.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# --- VPC ---
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "powergrid-vpc"
  cidr = "10.0.0.0/16"
  azs  = ["us-east-1a", "us-east-1b"]

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# --- EKS module ---
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.6.1"   # latest compatible version

  name               = "powergrid-eks"   # replaces old cluster_name
  kubernetes_version = "1.29"            # upgrade to fix Auto Mode issue
  subnet_ids         = module.vpc.private_subnets
  vpc_id             = module.vpc.vpc_id

  eks_managed_node_groups = {
    default = {
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = ["t3.medium"]
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


# --- ECR repository ---
resource "aws_ecr_repository" "ingest_api" {
  name = "ingest-api"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name        = "ingest-api"
    Environment = var.env_name
  }
}



