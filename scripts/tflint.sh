#!/bin/bash
set -e
echo "Running tflint..."
tflint --init
tflint
