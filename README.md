# DevOps Big Data Provisioning Project 🚀

This project automates the provisioning and setup of a Big Data lab on **Google Cloud Platform** using **Terraform**, **Ansible**, and **GitHub Actions**. It includes the setup of:

- ✅ Automated SSH key generation and VM access

---

## 🔐 GitHub Repository Secrets Setup

Go to your GitHub repository → `Settings` → `Secrets and variables` → `Actions` → `New repository secret`.

Add the following secrets:

| Secret Name               | Description                                                  |
| ------------------------- | ------------------------------------------------------------ |
| `GOOGLE_CREDENTIALS_JSON` | Paste entire content of service-account JSON (base64 or raw) |
| `SSH_PRIVATE_KEY`         | Your private SSH key used by Ansible                         |
| `SSH_PUBLIC_KEY`          | Your public SSH key for VM provisioning                      |
| `SENDGRID_API_KEY`        | _(Optional)_ For sending user credentials via email          |

---

## 📁 Project Structure

.
├── .github/

│ └── workflows/

│ └── deploy.yml # GitHub Actions CI/CD pipeline

├── terraform/
│ ├── main.tf # Terraform GCP VM creation
│ ├── variables.tf
│ └── outputs.tf
├── ansible/
│ ├── inventory.ini
│ ├── playbook.yml # Installs Hadoop, Hive, HBase, etc.
│ └── group_vars/
│ └── all.yml # Contains user credentials (encrypted or hashed)
├── scripts/
│ └── send_email.py # Optional script for sending credentials
└── README.md

## ✅ How to Use

### Step 1: Prepare Service Account for GCP

- Create a GCP service account with `Editor` role
- Download the JSON key and copy it into GitHub secret `GOOGLE_CREDENTIALS_JSON`

### Step 2: Prepare SSH Keys

Generate a key pair and copy the contents into GitHub Secrets:

```bash
ssh-keygen -t rsa -f gcp-key -m PEM

gcp-key: Add content to SSH_PRIVATE_KEY

gcp-key.pub: Add content to SSH_PUBLIC_KEY

### Step 3: Trigger CI/CD Pipeline

Once secrets are set, push any commit to the repository or manually trigger the GitHub Action.

## ⚙️ GitHub Action Workflow (.github/workflows/deploy.yml)

This workflow will:

Authenticate with GCP using the service account

Run Terraform to provision 16 VMs

SSH into each and run Ansible playbook to configure:
```
