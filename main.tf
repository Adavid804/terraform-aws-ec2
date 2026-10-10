variable "ami_id" {
  description = "The AMI ID to use for the instance. If empty, Amazon Linux 2023 will be used."
  type        = string
  default     = ""
}

data "aws_ami" "amazon_linux_2023" {
  count = var.ami_id == "" ? 1 : 0

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "this" {
  ami           = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux_2023[0].id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids      = var.vpc_security_group_ids
  iam_instance_profile        = var.iam_instance_profile

  key_name = var.key_name

  # Security / Well-Architected: IMDSv2
  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "required"
  }

  # Security / Well-Architected: EBS Encryption
  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    volume_size = var.root_volume_size
    kms_key_id  = var.root_volume_kms_key_id
  }

  monitoring = var.monitoring

  tags = merge(
    {
      "Name" = var.instance_name
    },
    var.tags
  )
}
