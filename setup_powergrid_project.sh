#!/bin/bash
# PowerGrid Telemetry Pipeline project scaffold
# Run this inside your new project folder

echo "íº€ Creating PowerGrid Telemetry project structure..."

mkdir -p infra \
  services/{simulator,ingest-api,stream-processor,grafana} \
  k8s \
  .github/workflows \
  docs

# Create placeholder files
touch infra/{terraform.tf,variables.tf,outputs.tf} \
  services/simulator/app.py \
  services/ingest-api/app.py \
  services/stream-processor/app.py \
  services/grafana/Dockerfile \
  k8s/{deployment.yaml,service.yaml} \
  .github/workflows/ci-cd.yml \
  README.md

# Initialize Git
git init -q
git add .
git commit -m "Initial project scaffold" -q

echo "âœ… Done! PowerGrid Telemetry folder structure created."

