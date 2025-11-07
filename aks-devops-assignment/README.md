# AKS DevOps Assignment

This repository provisions a production-like AKS environment on Azure, deploys a sample microservice, sets up Prometheus & Grafana monitoring, runs Terraform security scans, and automates CI/CD via GitHub Actions.

## Quick Start
1. Create Azure backend for Terraform state (one-time).
2. Configure GitHub repository and secrets.
3. Run **infra** workflow to create AKS/ACR, etc.
4. Push app code to trigger **app-ci-cd** workflow.
5. Install monitoring and access Grafana dashboards.
