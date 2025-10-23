#!/bin/bash

# Build and run script in one command
# Usage: ./scripts/build-and-run.sh

set -e

echo "🏗️  Building and running CallForPaperApp..."
echo "========================================="
echo ""

# Build
echo "🔨 Step 1: Building..."
./scripts/build.sh

echo ""
echo "🚀 Step 2: Running..."
./scripts/run-local.sh
