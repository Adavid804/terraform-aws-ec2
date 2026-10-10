output "instance_id" {
  description = "The ID of the instance"
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "The ARN of the instance"
  value       = aws_instance.this.arn
}

output "instance_public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = aws_instance.this.public_ip
}

output "instance_private_ip" {
  description = "The private IP address assigned to the instance"
  value       = aws_instance.this.private_ip
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_instance.this.tags_all
}
