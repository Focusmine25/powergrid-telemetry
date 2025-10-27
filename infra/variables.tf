# AWS region
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}


# VPC
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Subnets
variable "private_subnets" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.101.0/24","10.0.102.0/24"]
}

# EKS Cluster
variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "powergrid-eks"
}

variable "eks_node_group_name" {
  description = "Node group name"
  type        = string
  default     = "powergrid-nodes"
}

variable "eks_node_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "eks_desired_capacity" {
  type    = number
  default = 2
}

variable "vpc_id" {
  type = string
}

variable "env_name" {
  description = "Environment name (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

