# Zuri Market Platform

A DevOps capstone project demonstrating infrastructure as code, containerisation, CI/CD, Kubernetes deployment, monitoring, security controls and automated health checks for the Zuri Market application.

## Repositories

- **Platform:** https://github.com/Rike12/zuri-platform
- **Backend:** https://github.com/Rike12/zuriapp-backend
- **Frontend:** https://github.com/Rike12/zuriapp-frontend

## Architecture overview

- **Network (Terraform):** VPC infrastructure in AWS region `eu-west-2`, with public and private subnet configuration across two Availability Zones.
- **Security groups:** HTTP/HTTPS access and restricted SSH access based on the administrator CIDR configuration.
- **Terraform:** reusable VPC, security-group and compute modules. Development and production have separate environment configurations and S3 remote-state keys with state locking.
- **Containers:** Docker images for the backend and frontend, with Docker Compose available for local development.
- **Kubernetes:** Deployments, Services, ConfigMaps, Secrets, service accounts, RBAC and an Ingress resource are defined in `k8s/`.
- **CI/CD:** GitHub Actions workflows in the application repositories run application checks, build container images, scan with Trivy and publish images to GHCR.
- **Monitoring:** Prometheus scrapes backend metrics and Grafana presents request rate, availability, route/status counts, P95 latency and HTTP 5xx error rate.
- **Automation:** a Bash health-check script records timestamped results and is scheduled through cron.

See [docs/architecture.md](docs/architecture.md) for the architecture diagram.

## Run locally

Start the application stack:

```bash
docker compose up --build -d
docker compose ps
```

Check backend health:

```bash
curl http://localhost:5000/health
```

The expected response is a healthy status. The frontend is normally available at http://localhost:8080, depending on the Compose port mapping.

Stop the stack:

```bash
docker compose down
```

## Run in AWS with Terraform

Review the production configuration before provisioning:

```bash
cd terraform/environments/prod
terraform init
terraform validate
terraform plan
```

Supply required variables such as the administrator CIDR through an untracked `terraform.tfvars` file or an appropriate environment-specific configuration.

Review the plan carefully before running `terraform apply`. Never commit credentials, sensitive variable files or local environment files.

**Environment status:** the development configuration uses the compute module. The production configuration currently includes the VPC and security-group modules; production compute provisioning remains to be completed if required by the final scope.

## Container images

The application images are published to GitHub Container Registry (GHCR):

```bash
docker pull ghcr.io/rike12/zuriapp-backend:latest
docker pull ghcr.io/rike12/zuriapp-frontend:latest
```

Images are tagged with the commit SHA and `latest`, where configured by the workflows.

## CI/CD and image security

GitHub Actions is used for automated application delivery. The application workflows cover installation, linting, testing, build checks, Docker image builds, Trivy vulnerability scanning and publishing to GHCR.

Trivy is configured to fail builds for HIGH or CRITICAL findings. A frontend image scan identified HIGH-severity Alpine package vulnerabilities involving libexpat, pcre2 and tiff. The runtime image was hardened using `apk upgrade --no-cache`.

The backend image was also hardened through base-image pinning, package upgrades and removal of npm from the runtime image.

## Kubernetes

Kubernetes manifests are stored in `k8s/` and include backend and frontend Deployments and Services, ConfigMaps, service accounts, RBAC resources and an Ingress definition.

Useful verification commands:

```bash
kubectl get nodes
kubectl get deployments
kubectl get pods
kubectl get services
kubectl get ingress
```

The application workloads have been verified as running in a local Kind cluster. For the local presentation, the frontend and backend can be accessed using port-forwarding:

```bash
kubectl port-forward service/zuri-frontend 8081:80
```

In a second terminal:

```bash
kubectl port-forward service/zuri-backend 5001:5000
```

Then open http://localhost:8081 and check http://localhost:5001/health.

**Ingress note:** the Ingress resource is defined, but an Ingress controller must be installed and configured before it can route traffic. Port-forwarding is the current local demonstration method.

## Monitoring with Prometheus and Grafana

Prometheus is configured to scrape backend application metrics. The Grafana dashboard contains panels for:

1. HTTP request rate
2. Backend target availability
3. HTTP requests by route and status
4. P95 HTTP request latency
5. HTTP 5xx server-error rate

The Prometheus configuration is in `monitoring/prometheus.yml`. Grafana dashboard screenshots are part of the project evidence.

## Health-check automation

The Bash script in `scripts/health-check.sh` checks the backend health endpoint using curl and appends a timestamped result to a report file. The script supports environment variables for the target URL and report destination.

Cron is configured to run a health check daily at 09:00. The report contains authentic results, including earlier DOWN responses recorded before the health endpoint was available.

The collected history began on 9 October 2026 and is not yet sufficient to demonstrate several days of continuous daily records. Additional genuine records should be collected rather than fabricated.

See [docs/health-check-evidence.md](docs/health-check-evidence.md) for supporting documentation.

## Security controls

- Trivy vulnerability scanning for container images.
- Restricted SSH access through the Terraform security-group configuration.
- Kubernetes service accounts, Role and RoleBinding for scoped ConfigMap access.
- Kubernetes Secret for backend sensitive configuration.
- Git ignore rules for sensitive local files such as `.env` and `*.tfvars`.

**Remaining security work:** AWS Secrets Manager integration has not yet been verified. A dedicated Terraform IAM module and its least-privilege permissions also remain outstanding.

## Jenkins vs GitHub Actions

GitHub Actions is hosted, integrates directly with GitHub and avoids maintaining a separate CI server. Jenkins offers flexibility and a large plugin ecosystem but requires the team to maintain and secure its infrastructure. For a small team without a dedicated platform engineer, GitHub Actions is a practical choice.

## Evidence

Store evidence in `docs/` or a dedicated `docs/evidence/` directory, and link to the actual files before submission.

Recommended evidence:

- Architecture diagram
- Grafana dashboard screenshots
- Backend and frontend GitHub Actions runs
- Failed Trivy scan and remediation
- GHCR package pages
- Terraform validation and plan output for both environments
- Kubernetes workloads, Services and RBAC
- Cron configuration and health-report entries
- Pull request review and branch-protection evidence, if configured

## Remaining work

- Verify AWS Secrets Manager integration and permissions.
- Add a dedicated Terraform IAM module if required by the brief.
- Complete production compute configuration if required.
- Install an Ingress controller for end-to-end Ingress routing.
- Add a SonarQube quality gate or an accepted equivalent.
- Collect authentic health-check records over multiple days.
- Confirm evidence screenshots are committed and linked.
- Verify pull-request review and branch-protection requirements.

ArgoCD is an optional GitOps extension and is not required for the core deployment demonstration.


[200~EOF~
