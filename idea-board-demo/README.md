# Cloud-Agnostic Terraform Repo (AWS + GCP)

This Terraform repo can deploy the same stack to **AWS** or **GCP** by changing a single variable `cloud`.

Stack includes:
- VPC / Network
- Kubernetes cluster (GKE on GCP, EKS on AWS)
- PostgreSQL DB (Cloud SQL on GCP, RDS on AWS)
- Dockerized backend + frontend apps

## Usage

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and edit values.
2. Initialize Terraform: `terraform init`
3. Plan: `terraform plan -var-file="terraform.tfvars"`
4. Apply: `terraform apply -var-file="terraform.tfvars" -auto-approve`
5. Use `terraform output` to get `kubeconfig` and DB connection info
6. Deploy Kubernetes manifests using `kubectl`.


# Idea Board (Minimal) - React + FastAPI + PostgreSQL + Docker

This repository contains a minimal "Idea Board" application:

- React frontend (Vite)
- FastAPI backend
- PostgreSQL database
- Dockerfiles for frontend and backend
- docker-compose for local development

## Quick start (requires Docker & Docker Compose)

1. Clone the repo (or download the ZIP) and change into the project directory.
2. Build and start the stack:
```bash
docker-compose up --build
```
3. Open the frontend: http://localhost:3000  
   The backend API (optional): http://localhost:8000/api/ideas

## Notes

- Frontend uses Vite. To run locally without Docker:
  - `cd frontend`
  - `npm install`
  - `npm run dev` (requires Node.js >= 18)

- Backend:
  - `cd backend`
  - `pip install -r requirements.txt`
  - `uvicorn app.main:app --reload --host 0.0.0.0 --port 8000`

- The docker-compose file exposes ports 3000 (frontend), 8000 (backend), and 5432 (database).

## Files of interest
- `frontend/` (React + Vite)
- `backend/` (FastAPI)
- `docker-compose.yml`

