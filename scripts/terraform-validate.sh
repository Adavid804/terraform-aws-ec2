#!/bin/bash
set -e
echo "Running terraform validate..."
terraform init -backend=false
terraform validate
