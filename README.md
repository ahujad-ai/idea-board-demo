# 🧠 Idea Board — AI-First Cloud-Agnostic DevOps Platform

An intelligent, automated, multi-cloud DevOps platform integrating AI-assisted automation, Terraform-based infrastructure, and a full-stack containerized application deployed across **GCP** and **AWS**.

---

## 🏗️ Architecture Overview

| Layer | Technology | Purpose |
|:------|:------------|:---------|
| **Frontend** | React + Vite | User interface for submitting and viewing ideas |
| **Backend** | FastAPI (Python) | REST API to store and retrieve ideas |
| **Database** | PostgreSQL | Persistent data layer |
| **IaC** | Terraform | Cloud-agnostic modular infrastructure |
| **Orchestration** | Kubernetes (GKE/EKS) | Deployment and scaling of containers |
| **AI Layer** | OpenAI via GitHub Actions | Automatic Terraform analysis and AI-driven deployment workflows |
| **Containerization** | Docker | Consistent build and runtime environments |

```
Frontend  →  Backend  →  PostgreSQL
   |           |            |
   +-----------+------------+
           Kubernetes
              |
           Terraform
          (AWS / GCP)
```

---

## ⚙️ Local Setup with Docker Compose

### Prerequisites
* Docker Desktop
* `docker compose` plugin

### Steps
```bash
git clone https://github.com/ahujad-ai/idea-board-demo.git
cd idea-board-demo
docker compose up --build
```

Access:
* Frontend → http://localhost:3000  
* Backend  → http://localhost:8000/api/ideas

---

## ☁️ Cloud Deployment ( Terraform + Kubernetes )

The same Terraform modules deploy to either **AWS** or **GCP** by changing a few variables.

### Prerequisites
* Enable GCP Permissions and Project settings.
Before you begin, make sure you have:

✅ [Google Cloud SDK installed](https://cloud.google.com/sdk/docs/install)  
✅ Logged in with your Google account:

```bash
gcloud auth login
gcloud components install gke-gcloud-auth-plugin
gcloud projects create idea-board-demo --name="Idea Board Demo" --set-as-default
gcloud billing projects link idea-board-demo --billing-account <billing-account-id>
gcloud services enable compute.googleapis.com container.googleapis.com sqladmin.googleapis.com artifactregistry.googleapis.com cloudresourcemanager.googleapis.com
gcloud config set project idea-board-demo
```

### Configure Terraform
Edit `terraform.tfvars`:
```hcl
cloud       = "gcp"        # or "aws"
region      = "asia-south1"
project_id  = "your-gcp-project-id"
db_password = "your-db-password"
```

### Provision Infrastructure
```bash
./deploy.sh gcp
```

Creates VPC, GKE/EKS cluster, CloudSQL/RDS instance, and Artifact/ECR registry.

### Build and Push Images
```bash
./build_and_push_images.sh gcp
```

### Verify
```bash
gcloud container clusters get-credentials idea-board-cluster --region asia-south1
kubectl get pods
kubectl get svc
kubectl get ingress
```

---

## 🤖 AI-Powered CI/CD Workflows

### 1️⃣ Terraform AI Review

File: `.github/workflows/terraform-ai-review.yml`

**Purpose:** Automatically analyzes Terraform configurations using GPT-5 to create architecture summaries, risk assessments, and reports.

**Features**
* Offline Terraform analysis (`terraform graph`)
* AI-generated documentation (PDF & Markdown)
* PR comment summary and insights

Required Secret:
```
OPENAI_API_KEY = <your-openai-api-key>
```

---

### 2️⃣ AI-Assisted Deployment Preview

File: `.github/workflows/ai-deploy-preview.yml`

**Purpose:** Automatically interprets PR comments like `/deploy-preview` and generates safe, AI-driven Kubernetes deployment commands.

#### Supported Commands

| Comment | Description |
|:--------|:-------------|
| `/deploy-preview` | Deploys a preview environment using generated kubectl commands |
| `/deploy-preview dry-run` | Posts AI-generated commands as a comment (no execution) |

#### How It Works
1. Developer comments `/deploy-preview` on a PR.  
2. Workflow triggers the AI model (GPT-5).  
3. GPT-5 generates **safe, executable `kubectl apply` commands**.  
4. Workflow sanitizes the commands and executes or dry-runs them.  
5. The bot posts a **deployment summary** as a PR comment.

#### Example PR Comment (Dry Run)
```
🤖 AI-Assisted Deployment Result
Mode: Dry Run (No Execution)
Generated Commands:
kubectl apply -f ./k8s/frontend.yml
kubectl apply -f ./k8s/backend.yml
```

#### AI Safety Rules
* Executes only `kubectl apply` (no deletions or shell-side effects).
* Sanitizes LLM output before execution.
* Ensures all commands reference known manifests under `./k8s/`.

---

## 🌎 Cloud-Agnostic Infrastructure

### Module Structure
```
modules/
├── aws/
│   ├── eks/       → EKS cluster
│   ├── rds/       → RDS PostgreSQL
│   └── network/   → VPC and subnets
└── gcp/
    ├── gke/       → GKE cluster
    ├── cloudsql/  → CloudSQL PostgreSQL
    └── network/   → VPC and subnet
```

**Design Principles**
* Shared variable interface across clouds  
* Consistent naming and tagging  
* Easily extensible to Azure (AKS)  
* One CI/CD pipeline for all providers  

---

## 🧠 Combined AI Pipelines Summary

| Pipeline | Purpose | AI Role |
|:----------|:---------|:--------|
| `terraform-ai-review.yml` | Analyze Terraform infra | Generate architecture summary, risks, PDF reports |
| `ai-deploy-preview.yml` | Deploy preview via PR comment | Generate & execute Kubernetes deployment safely |

---

## 📂 Repository Layout
```
idea-board-demo/
├── backend/              # FastAPI service
├── frontend/             # React + Vite UI
├── docker-compose.yml    # Local stack
├── k8s/                  # Kubernetes manifests
├── terraform/            # IaC (AWS + GCP)
├── build_and_push_images.sh
├── deploy.sh
└── .github/workflows/    # AI-powered pipelines
```

---

## 🔮 Future Enhancements
* 🤖 Extend `/deploy-preview` to support `/rollback-preview`
* 🧩 AI-driven autoscaling & resource recommendations
* ☁️ Add Azure (AKS) and AWS EKS support
* 📈 Predictive cost and anomaly detection

---

## 🪪 Credits
Created for the  
**“AI-First Cloud-Agnostic DevOps Platform” Case Study Challenge**

---

## 🧾 License
Released under the MIT License.
