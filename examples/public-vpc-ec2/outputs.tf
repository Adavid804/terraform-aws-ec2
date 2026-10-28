output "vpc_id" {
  description = "ID of the VPC created by the VPC module."
  value       = module.vpc.vpc_id
}

output "aws_region" {
  description = "AWS Region containing the example resources."
  value       = var.aws_region
}

output "public_subnet_id" {
  description = "ID of the public subnet containing the instance."
  value       = module.vpc.public_subnet_ids[0]
}

output "instance_id" {
  description = "ID of the EC2 instance."
  value       = module.ec2.instance_id
}

output "instance_public_ip" {
  description = "Public IPv4 address assigned to the EC2 instance."
  value       = module.ec2.instance_public_ip
}
