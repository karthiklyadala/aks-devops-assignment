# aks-devops-assignment
# AKS DevOps Assignment

## Objective
Provision AKS, deploy app, implement monitoring, and automate CI/CD.

## Architecture Overview
- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- GitHub Actions for CI/CD
- Prometheus + Grafana for monitoring

## Steps Performed
1. **Infrastructure**
   - Terraform scripts in `terraform/` folder
   - Deployed AKS, ACR, and networking resources
   - Security scanned via Checkov/Terrascan

2. **Application Deployment**
   - Deployed sample web app on AKS (`app/`)
   - Ingress configured via `k8s/ingress.yaml`
   - Exposed at `http://<EXTERNAL-IP>.nip.io`

3. **Monitoring**
   - Installed Prometheus & Grafana using Helm
   - Verified metrics:
     - `container_cpu_usage_seconds_total`
     - `container_memory_working_set_bytes`
     - `rate(http_server_requests_total[5m])`
   - Imported dashboards:
     - Kubernetes Cluster
     - Workloads / Pods

4. **CI/CD Pipeline**
   - GitHub Actions workflow: `.github/workflows/deploy.yml`
   - On each push to `main`:
     - Builds Docker image → Pushes to ACR
     - Deploys to AKS automatically

5. **Terraform Security Scan**
   - Run Checkov:
     ```
     checkov -d terraform/
     ```
   - All checks passed ✅ (attach summary screenshot)


## Screenshots
- AKS running pods
- App running
- Grafana dashboards
- Terraform scan output
- CI/CD run success

<img width="1880" height="889" alt="image" src="https://github.com/user-attachments/assets/8a914480-4d6a-4c63-83fb-7be996ed4af3" />


<img width="1875" height="706" alt="image" src="https://github.com/user-attachments/assets/e78cdf8c-dc96-4a5e-93df-22d46b71adc0" />

<img width="658" height="90" alt="image" src="https://github.com/user-attachments/assets/cf3241c7-18b0-4cac-b624-2733c5e60c3a" />


<img width="1633" height="177" alt="image" src="https://github.com/user-attachments/assets/c07a6216-857a-4fca-8c91-7ce4a028e591" />

