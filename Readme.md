# 🧠 Brain Tasks App – End-to-End DevOps Project

This project demonstrates a complete **CI/CD pipeline and Kubernetes deployment** using **AWS, Docker, EKS, CodeBuild, CodePipeline, and Terraform**.

The goal is to showcase real-world DevOps practices including:

- Infrastructure provisioning
- Containerization
- CI/CD automation
- Kubernetes deployment & scaling
- Monitoring and health validation

---

## 🏗️ Architecture Overview

```
GitHub Repo
   |
   | (Webhook)
   v
AWS CodePipeline
   ├── Source (GitHub)
   ├── Build (CodeBuild → Docker → ECR)
   └── Deploy (CodeBuild → kubectl → EKS)
                      |
                      v
                Kubernetes (EKS)
                 ├── Deployment
                 ├── Service (LoadBalancer)
                 └── HPA (Auto-scaling)
```

---

## 📁 Repository Structure

```
.
├── application/
│   └── dist/                   # Built frontend assets
│
├── operation/
│   ├── Docker/
│   │   ├── Dockerfile
│   │   └── docker-compose.yml
│   │
│   ├── k8s/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── hpa.yaml
│   │
│   ├── scripts/
│   │   ├── build.sh
│   │   ├── compose.sh
│   │   ├── deploy.sh
│   │   ├── install_kube.sh
│   │   └── options.sh
│
├── buildspec-build.yml
├── buildspec-deploy.yml
├── README.md
```

---

## ☁️ AWS Infrastructure (Terraform)

### Components Created

- VPC + Subnets
- Internet Gateway & Routing
- EKS Cluster
- Node Group
- IAM roles for EKS & NodeGroup
- Security Groups
- IAM permissions for CodeBuild & ECR

---

## 🐳 Amazon ECR (Docker Registry)

Repository:

```
613622767668.dkr.ecr.us-east-2.amazonaws.com/brain-tasks-app
```

Used to store application images built by CodeBuild.

---

## 🗂️ S3 Artifact Storage

AWS CodePipeline requires an S3 bucket to store intermediate artifacts (build outputs, metadata).

Used for:

Passing source artifacts between pipeline stages

Storing build outputs from CodeBuild

Example:

brain-task-artifacts-<account-id>

Permissions:

Read/Write access granted to:

CodePipeline role

CodeBuild role

---

## 3️⃣ IAM Roles

🔐 IAM Roles Used

CodeBuild Role

Push images to ECR

Pull source from GitHub

Access S3 artifacts

Access EKS via kubectl

CodePipeline Role

Trigger CodeBuild stages

Read/write S3 artifacts

EKS Node Role

Pull images from ECR

---

## 🐳 Docker Setup

Purpose

Docker is used to containerize the application so it can run consistently across environments.

Files

operation/Docker/Dockerfile
→ Builds an NGINX-based image serving the frontend build.

operation/Docker/docker-compose.yml
→ Used locally and in CI for building and testing images consistently.

Why Docker?

Eliminates environment mismatch

Enables CI/CD automation

Required for Kubernetes workloads

---

## ☸️ Kubernetes (EKS)

Components

Deployment – Runs application pods

Service (LoadBalancer) – Exposes app publicly

HPA (Horizontal Pod Autoscaler) – Scales pods based on CPU usage

Key Characteristics

CPU-based autoscaling (60%)

Stateless deployment

Load balanced via AWS ELB

Health checks enabled

📂 Files located in:

operation/k8s/

---

## 🧠 Script Design (Why This Structure)

| Script            | Purpose                                                           |
| ----------------- | ----------------------------------------------------------------- |
| `build.sh`        | Builds Docker image                                               |
| `compose.sh`      | Helper/wrapper script && Unified entrypoint for build/push/deploy |
| `deploy.sh`       | Applies Kubernetes manifests                                      |
| `options.sh`      | Cleanup / remove resources && other utilities                     |
| `install_kube.sh` | Installs kubectl in CI runner                                     |

This separation allows:

- Clean CI execution
- Easy local testing
- Reusability across environments
- These scripts abstract complexity and allow reuse locally and in CI.

---

## 📊 Monitoring

- **CloudWatch Logs**: Build + deploy logs
- **Kubernetes metrics** via Metrics Server
- **HPA** monitors CPU usage
- Ready for Prometheus/Grafana extension

---

## 🔍 Validation Steps

```bash
kubectl get pods
kubectl get svc
kubectl get hpa
kubectl top pods
```

Access app:

```
http://<LoadBalancer-IP>
```

---

### 🚀 AWS CI/CD Pipeline Summary (ECR + CodeBuild + CodePipeline)

## 1️⃣ Amazon ECR (Elastic Container Registry)

Created a private ECR repository to store Docker images.

Used as the central image registry for the application.

Docker images are tagged (latest, timestamped tags) and pushed during CI.

Access managed using IAM permissions.

## 2️⃣ AWS CodeBuild

Configured CodeBuild project with managed Amazon Linux image.

Connected to GitHub repository as the source.

Uses a buildspec.yml file to:

Authenticate to Amazon ECR

Build Docker image using docker-compose

Tag the image

Push image to ECR

CodeBuild also installs required tools (Docker, kubectl) dynamically.

## 3️⃣ AWS CodePipeline

Automates the full CI/CD workflow.

Pipeline stages:

Source Stage – Pulls code from GitHub on every commit.

Build Stage – Triggers CodeBuild to build and push Docker image.

Deploy Stage – Uses CodeBuild to deploy the image to EKS using kubectl.

Uses S3 bucket internally to store build artifacts between stages.

## 4️⃣ Kubernetes (EKS)

EKS cluster hosts the application.

Kubernetes manifests include:

Deployment

Service (LoadBalancer)

HPA (Horizontal Pod Autoscaler)

Application is exposed via AWS LoadBalancer.

Scaling is CPU-based using HPA.

## 5️⃣ IAM & Security

IAM roles created for:

CodeBuild (ECR push, EKS access)

CodePipeline (artifact access)

## No hardcoded credentials — all access handled via IAM roles.

## 📌 Notes / Learnings

- CodeBuild works best when it **only builds or deploys**, not both.
- EKS requires IAM + networking to be correct or nodes won’t join.
- Using scripts inside CI avoids duplication and makes debugging easier.
- HPA requires metrics-server running properly.

---

## 🚀 Final Outcome

A production-grade CI/CD pipeline deploying a containerized application to AWS EKS with:

- Automated builds
- Secure image storage
- Zero-downtime deployments
- Horizontal scaling
- Full observability
- GitHub Repository
- Dockerized Application
- ECR Image
- EKS Cluster
- CI/CD Pipeline (CodePipeline + CodeBuild)
- Auto-scaling enabled
- Monitoring enabled
- Documentation completed
