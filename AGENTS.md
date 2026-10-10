# AGENTS.md

Welcome! If you are an AI agent or automated script managing this repository, please follow these instructions:

## Code Formatting and Validation
- Ensure all Terraform code is formatted by running `bash scripts/terraform-fmt.sh` or `terraform fmt -recursive`.
- Ensure all Terraform code is valid by running `bash scripts/terraform-validate.sh` or `terraform validate`.

## Linting and Security Checks
- We use `tflint` for linting. Run `bash scripts/tflint.sh` to execute linting checks.
- We use `trivy` for vulnerability and misconfiguration scanning. Run `bash scripts/trivy.sh` to check for security issues.

## Testing
- Tests are written in the `tests/` directory using Terraform tests (`.tftest.hcl`).
- Run `bash scripts/terraform-test.sh` to execute the tests.

## Documentation
- We use `terraform-docs` to auto-generate module documentation.
- Run `bash scripts/terraform-docs.sh` to inject the latest documentation into `README.md`.

## FinOps Guardrails
- Ensure you do NOT remove the FinOps variable validation in `variables.tf`. This module restricts instance types to t3.micro, t3.small, and t3.medium.
- Ensure cost allocation tags (`CostCenter`, `Environment`) are always required.

## Well-Architected Framework
- IMDSv2 must remain enabled (`http_tokens = "required"`).
- EBS encryption must remain enabled by default.
