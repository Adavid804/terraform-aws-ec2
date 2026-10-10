#!/bin/bash
set -e
echo "Running terraform-docs..."
terraform-docs -c .terraform-docs.yml .
