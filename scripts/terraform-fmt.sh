#!/bin/bash
set -e
echo "Running terraform fmt..."
terraform fmt -recursive
