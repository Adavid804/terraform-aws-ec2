provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  common_tags = {
    CostCenter  = var.cost_center
    Environment = var.environment
    Owner       = var.owner
  }
}

module "vpc" {
  source = "git::https://github.com/Adavid804/terraform-aws-vpc.git?ref=cec4cdacc954e5685823794df69c176fd934fd52"

  vpc_name             = var.name
  cidr_block           = var.vpc_cidr
  azs                  = [data.aws_availability_zones.available.names[0]]
  public_subnets       = [cidrsubnet(var.vpc_cidr, 8, 1)]
  enable_nat_gateway   = false
  enable_vpc_flow_logs = var.enable_vpc_flow_logs
  mandatory_tags       = local.common_tags
}

resource "aws_security_group" "instance_egress" {
  name_prefix = "${var.name}-"
  description = "No inbound access; allow the instance to reach the public internet"
  vpc_id      = module.vpc.vpc_id

  egress {
    description = "Allow outbound IPv4 traffic, including ICMP echo requests"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.name}-egress"
  })

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ssm" {
  name_prefix        = "${var.name}-"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags               = local.common_tags
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm" {
  name_prefix = "${var.name}-"
  role        = aws_iam_role.ssm.name
  tags        = local.common_tags
}

module "ec2" {
  source = "../.."

  instance_name               = var.name
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnet_ids[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.instance_egress.id]
  iam_instance_profile        = aws_iam_instance_profile.ssm.name
  tags                        = local.common_tags

  depends_on = [aws_iam_role_policy_attachment.ssm_core]
}
