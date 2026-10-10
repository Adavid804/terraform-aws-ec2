#!/bin/bash
set -e
echo "Running terraform plan..."
terraform init -backend=false
terraform plan
