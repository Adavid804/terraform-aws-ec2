provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

variables {
  ami_id                      = "ami-12345678"
  instance_name               = "test-instance"
  subnet_id                   = "subnet-12345678"
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["sg-12345678"]
  tags = {
    CostCenter  = "12345"
    Environment = "Dev"
  }
}

run "valid_plan" {
  command = plan

  assert {
    condition     = aws_instance.this.instance_type == "t3.micro"
    error_message = "Instance type does not match the provided variable."
  }

  assert {
    condition     = aws_instance.this.subnet_id == "subnet-12345678"
    error_message = "Subnet ID does not match the provided variable."
  }

  assert {
    condition     = aws_instance.this.associate_public_ip_address
    error_message = "The public connectivity example requires a public IPv4 address."
  }

  assert {
    condition     = aws_instance.this.metadata_options[0].http_tokens == "required"
    error_message = "IMDSv2 must remain required."
  }

  assert {
    condition     = aws_instance.this.root_block_device[0].encrypted
    error_message = "The root EBS volume must remain encrypted."
  }
}
