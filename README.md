# Zuri Market Platform

## Repositories
- Platform (this repo): https://github.com/Rike12/zuri-platform
- Backend: https://github.com/Rike12/zuriapp-backend
- Frontend: https://github.com/Rike12/zuriapp-frontend

## Architecture overview
AWS VPC (eu-west-2) with 2 public subnets (ingress, k3s host) and 2 private subnets (future data/internal workloads) across two AZs. Internet gateway on the public route table. Security group allows 80/443 from the internet and SSH only from the administrator's /32. Terraform is split into reusable modules (vpc, security-groups) with separate dev and prod environments, using an S3 remote backend with lockfile state locking. Applications run as containers, locally via Docker Compose and on Kubernetes via manifests in k8s/. Each app repo has its own GitHub Actions workflow (lint, test, Trivy scan) and Dockerfile.

## Run locally
    docker compose up --build

## Run in the cloud
    cd terraform/environments/prod
    echo 'admin_cidr = "<your-ip>/32"' > terraform.tfvars
    terraform init && terraform plan && terraform apply

## Health check
scripts/healthcheck.sh appends a timestamped UP/DOWN line to ~/health_report.txt. Cron runs it daily at 09:00.

## Jenkins vs GitHub Actions
GitHub Actions is hosted, needs no server to maintain, and sits next to the code, which suits a 3-developer team with no dedicated platform engineer. Jenkins is more flexible and has many plugins, but we would have to run, patch and secure it ourselves.

## Evidence
(add screenshots: PR with review comment, terraform apply, dev plan, crontab and health report, green Actions runs)

## Not completed
- SonarQube quality gate
- Image push to a container registry
- ArgoCD (optional extension)
- Prometheus/Grafana monitoring (unless built)
- Secrets Manager integration (unless built)
- EC2 and IAM Terraform modules
