#!/bin/bash
set -e
echo "Running terraform test..."
terraform init -backend=false
terraform test
