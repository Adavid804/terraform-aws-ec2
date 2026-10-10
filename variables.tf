variable "instance_name" {
  description = "Name to be used on all resources as identifier"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start. Restricted to t3.micro, t3.small, t3.medium for FinOps guardrails."
  type        = string
  default     = "t3.micro"

  validation {
    condition     = contains(["t3.micro", "t3.small", "t3.medium"], var.instance_type)
    error_message = "The instance_type must be one of: t3.micro, t3.small, t3.medium to comply with FinOps cost guardrails."
  }
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in (supports public, private, and database subnets)"
  type        = string
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC. Should be true for public subnets, false for private and database subnets."
  type        = bool
  default     = false
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = []
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile."
  type        = string
  default     = null
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Size of the root volume in gigabytes"
  type        = number
  default     = 20
}

variable "root_volume_kms_key_id" {
  description = "Amazon Resource Name (ARN) of the KMS Key to use when encrypting the root volume. Must be provided if custom encryption is needed, otherwise uses default AWS KMS key."
  type        = string
  default     = null
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources. Must contain CostCenter and Environment for FinOps."
  type        = map(string)
  default     = {}

  validation {
    condition     = contains(keys(var.tags), "CostCenter") && contains(keys(var.tags), "Environment")
    error_message = "Tags must include 'CostCenter' and 'Environment' for FinOps cost allocation."
  }
}
