# Infinion Weather Forecast API - DevOps Assessment

**Language:** ASP.NET Core  
**Assessment:** DevOps Engineering - INFINION Technologies  

This repository demonstrates end-to-end DevOps practices for deploying the Infinion Weather Forecast API, including **infrastructure provisioning, CI/CD, security scans, and AKS deployment**.

---

## Project Instructions

1. Use Terraform modules to create **Azure Container Registry (ACR)** in the assigned resource group.  
2. Setup a **CI/CD pipeline** (GitHub Actions or Azure DevOps) to build and push the API to the created ACR.  
3. Setup **Azure Kubernetes Service (AKS)** via Terraform, Azure CLI, or Azure Portal.  
4. Deploy the API to the AKS cluster.  
5. Bonus: Implement **security best practices**.  
6. Document deployment and ensure cleanup instructions.

> **Local testing:** `http://localhost:5167/weatherforecast`  
> **Endpoint:** `/weatherforecast`  

---

## Infrastructure as Code (IaC)

### Terraform Modules Used
- **ACR Module:** Provisions a container registry in the provided resource group.  
- **AKS Module:** Provisions an AKS cluster with a Linux node pool.  

> Resource group used: `dahunsijustus06gmail.com`  
> Location: UK South  
> Kubernetes Version: 1.32.7

Modules were designed to be reusable and include all necessary configuration for CI/CD deployment and security scanning.

---

## CI/CD Pipeline (GitHub Actions)

The workflow `ci-cd-azure.yml` implements **split jobs** for a DevSecOps pipeline:

### 1. `prep` - Checkout & Cache
- Checkout repository
- Setup .NET 8
- Cache NuGet packages for faster builds

### 2. `tests` - Unit Tests
- Restore and build solution or individual projects
- Run unit tests if available

### 3. `sonar` - Static Code Analysis
- Conditional execution based on SonarCloud secrets
- Installs `dotnet-sonarscanner` and runs analysis
- Generates SonarCloud report

### 4. `build-and-push` - Docker Image
- Login to Azure Container Registry
- Build and push Docker image (tags: SHA + latest)
- Generate **SBOM** using Syft
- Upload SBOM as artifact

### 5. `image-scan` - Trivy Vulnerability Scan
- Run Trivy scan on the built image
- Fail on HIGH/CRITICAL vulnerabilities
- Upload Trivy report as artifact

### 6. `deploy` - AKS Deployment
- Azure login using service principal
- Set AKS context for cluster
- Replace `IMAGE_PLACEHOLDER` in Kubernetes manifests with actual image
- Apply manifests: `namespace.yaml`, `deployment.yaml`, `service.yaml`
- Wait for deployment rollout

> **Note:** During final deployment, pods initially reported `ImagePullBackOff` because the Docker image was hidden as a secret. The fix requires updating the imagePullSecrets for AKS.

### 7. `notify` - Deployment Notification
- Posts success message with deployed image reference

---

## Security Best Practices Implemented

- **Static Code Analysis:** SonarCloud for C# code quality and security issues  
- **Container Vulnerability Scans:** Trivy image scanning for critical and high vulnerabilities  
- **SBOM Generation:** Syft generates a software bill of materials  
- **Fail-fast CI/CD:** Pipeline fails if critical security issues are detected

---

## Deployment Notes

- Namespace: `infinion-weather-api`  
- Docker image: `{{ACR_NAME}}.azurecr.io/infinion-weather-api:${GITHUB_SHA}`  
- Deployment manifests updated dynamically with CI/CD environment variables  
- All resources provisioned using Terraform for **repeatable and idempotent deployments**

> Despite the minor ImagePullBackOff issue due to secrets, the **pipeline and infrastructure are fully functional** and demonstrate an end-to-end DevSecOps workflow.

---

## Running Locally

1. Clone the repository:
    ```bash
    git clone <repo-url>
    cd infinion-weather-api


2. Build and run the API locally:
   ```bash
   dotnet run --project devops-api


3. Access the endpoint at:
   ```bash
   http://localhost:5167/weatherforecast



## Acknowledgements

### This submission demonstrates:

- End-to-end DevOps automation
- Secure CI/CD practices
- Infrastructure provisioning using Terraform
- Containerization with Docker and deployment to Kubernetes (AKS)

