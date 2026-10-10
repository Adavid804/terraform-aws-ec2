provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

variables {
  ami_id        = "ami-12345678"
  instance_name = "test-instance"
  subnet_id     = "subnet-12345678"
  instance_type = "t3.micro"
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
}
