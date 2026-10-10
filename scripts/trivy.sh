#!/bin/bash
set -e
echo "Running trivy config..."
trivy config .
