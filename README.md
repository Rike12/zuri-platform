# Zuri Market Platform

Platform repo for the Zuri Market DevOps capstone: infrastructure, Kubernetes manifests, local stack and automation around the two-service app.

## Repositories
- Platform (this repo): https://github.com/Rike12/zuri-platform
- Backend: https://github.com/Rike12/zuriapp-backend
- Frontend: https://github.com/Rike12/zuriapp-frontend

## Architecture overview
- **Network (Terraform):** one VPC (eu-west-2) with 2 public subnets (ingress, k3s host) and 2 private subnets (internal workloads) across two AZs. An internet gateway serves the public route table only.
- **Security group:** 80/443 open to the internet, SSH only from the administrator's single /32 IP. No 0.0.0.0/0 on SSH or databases.
- **Terraform layout:** reusable modules (vpc, security-groups) called by `environments/dev` and `environments/prod`, each with its own state key in an S3 backend with lockfile locking.
- **Containers:** one Dockerfile per app repo (multi-stage, Alpine base, npm removed from the backend runtime image). `docker-compose.yml` starts the full stack.
- **Kubernetes:** Deployments, Services, ConfigMaps and an Ingress for both services in `k8s/`.
- **CI (GitHub Actions, one workflow per app repo):** install, lint, test, build, Docker build, Trivy scan (fails on HIGH/CRITICAL), then push to GHCR.
- **Automation:** a Bash health check appends a timestamped UP/DOWN line to `~/health_report.txt`, scheduled daily at 09:00 with cron.

## Run locally
    docker compose up --build -d
    curl http://localhost:5000/health      # backend
    # frontend: http://localhost:8080

## Run in the cloud
    cd terraform/environments/prod
    echo 'admin_cidr = "<your-ip>/32"' > terraform.tfvars   # never commit this file
    terraform init
    terraform plan
    terraform apply

## Container images
    docker pull ghcr.io/rike12/zuriapp-backend:latest
    docker pull ghcr.io/rike12/zuriapp-frontend:latest

Images are tagged with the commit SHA and `latest`.

## Health check
The script appends one line per run, never overwriting, e.g. `2026-10-09 00:11:17 | http://localhost:5000/health | UP (200)`. It lives in `scripts/` in this repo; the deployed copy runs from the home directory. Cron entry:

    0 9 * * * /home/mutiat/healthcheck.sh http://localhost:5000/health

The first two lines in the report are real DOWN (404) results from before the backend container was rebuilt with the `/health` route. They are kept on purpose.

## Security notes
- Trivy fails the build on HIGH/CRITICAL findings. On the frontend it blocked a build on 3 HIGH Alpine CVEs (libexpat, pcre2, tiff); the fix was `apk upgrade --no-cache` in the runtime stage.
- Backend image was hardened in several commits: pinned base digest, `apk upgrade`, npm removed from the runtime image.
- SSH is limited to one admin IP. `.env`, `*.tfvars`, `.terraform/` and `*.bak` are gitignored.

## Jenkins vs GitHub Actions
GitHub Actions is hosted, needs no server to maintain, and lives next to the code, which suits a 3-developer team with no dedicated platform engineer. Jenkins is more flexible and has a large plugin ecosystem, but Zuri would have to run, patch and secure it themselves. For this team, Actions is the better fit.

## Evidence
Screenshots are in `docs/` (add before submitting):
- Pull request with review comment
- `terraform apply` (prod) and `terraform plan` (dev)
- Backend and frontend CI runs, including the failed Trivy run and the fix
- GHCR package pages (backend, frontend)
- `crontab -l` and the health report

## Not completed
- SonarQube quality gate
- Prometheus and Grafana dashboard with real data
- AWS Secrets Manager and Kubernetes Secrets
- Terraform compute (EC2) and IAM role modules
- Kubernetes RBAC
- ArgoCD (optional extension)
- Architecture diagram (to be added in `docs/`)
- Several days of health report history (cron started 9 October)
