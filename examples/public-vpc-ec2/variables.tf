variable "aws_region" {
  description = "AWS Region in which to create the example resources."
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Name prefix for the example resources."
  type        = string
  default     = "public-vpc-ec2"
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the example VPC."
  type        = string
  default     = "10.42.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "instance_type" {
  description = "EC2 instance type. The module's FinOps guardrail permits t3.micro, t3.small, or t3.medium."
  type        = string
  default     = "t3.micro"
}

variable "environment" {
  description = "Environment tag used for cost allocation."
  type        = string
  default     = "dev"
}

variable "cost_center" {
  description = "Required cost-center tag value."
  type        = string

  validation {
    condition     = length(trimspace(var.cost_center)) > 0
    error_message = "cost_center must not be empty."
  }
}

variable "owner" {
  description = "Owner tag value."
  type        = string
  default     = "terraform"
}

variable "enable_vpc_flow_logs" {
  description = "Enable VPC Flow Logs. Disabled for the minimal example; enable for persistent environments and use a KMS key."
  type        = bool
  default     = false
}
