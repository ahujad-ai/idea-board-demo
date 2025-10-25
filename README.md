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
| **AI Layer** | OpenAI via GitHub Actions | Automatic Terraform analysis and documentation |
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

gcloud projects create idea-board-demo \
  --name="Idea Board Demo" \
  --set-as-default

gcloud projects list

# Example Output
#PROJECT_ID         NAME               PROJECT_NUMBER
#idea-board-demo    Idea Board Demo    483237135245

# Attach Project to billing account
gcloud billing accounts list

gcloud billing projects link idea-board-demo \
  --billing-account <billing-account-id>

gcloud services enable \
  compute.googleapis.com \
  container.googleapis.com \
  sqladmin.googleapis.com \
  artifactregistry.googleapis.com \
  cloudresourcemanager.googleapis.com


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

## 🤖 AI-Powered CI/CD Pipeline

A GitHub Actions workflow uses an **LLM** to analyze Terraform during pull requests.

**Features**
* Validates Terraform syntax offline  
* Builds a dependency graph (`terraform graph`)  
* Generates summaries, cost drivers, and risks  
* Produces PDF & Markdown reports  
* Posts AI summary as a PR comment  

Workflow file: `.github/workflows/terraform-ai-review.yml`

### Required Secret
```
OPENAI_API_KEY = <your-openai-api-key>
```

**Example PR Output**
> • Creates a GKE cluster, VPC-native network, and PostgreSQL CloudSQL instance.  
> • Recommends private networking and autoscaling for non-prod clusters.

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

## 🧰 GitHub Actions Pipeline Flow

| Step | Description |
|:----:|:-------------|
| 1 | Validate Terraform (offline) |
| 2 | Generate graph of resources |
| 3 | Call OpenAI for summary |
| 4 | Create and upload PDF report |
| 5 | Comment results on PR |

---

## 📊 Example AI Report

```
Resource Type                  Count
google_container_cluster        1
google_container_node_pool      1
google_sql_database_instance    1
aws_vpc                         1
aws_eks_cluster                 1
aws_db_instance                 1
```

**AI Summary**
> Terraform provisions a single-node GKE/EKS cluster and CloudSQL/RDS instance with private VPC networking.  
> Infrastructure follows modular, cost-efficient patterns.  
> Recommendations: enable private IP for databases and autoscaling for production.

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
* 🤖 Natural-language `/deploy-preview` commands in PRs  
* 🧩 AI-driven autoscaling policy suggestions  
* ☁️ Add Azure (AKS) and AWS support  
* 📈 Automatic cost forecast and impact analysis  

---

## 🪪 Credits

Created for the  
**“AI-First Cloud-Agnostic DevOps Platform” Case Study Challenge**


---

## 🧾 License
Released under the MIT License.
