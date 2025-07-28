# 🚀 DevOps Big Data Lab Setup (Terraform + Ansible + Docker + Email Alerts)

This project automates the setup of a full-fledged Big Data environment using **Terraform, Ansible, Docker**, and **email notifications**.

---

## 🧱 Stack Overview

| Tool       | Purpose                         |
|------------|----------------------------------|
| Terraform  | Provision VMs on GCP             |
| Ansible    | Configure Big Data services      |
| Docker     | Quick sandbox for Hadoop stack   |
| Jenkins    | Automate deployments             |
| SendGrid / Gmail | Email notifications        |

---

## ☁️ GCP Infrastructure (Terraform)

- Provision 16 GCP VM instances
- Output IPs to `inventory.ini` for Ansible
- Example resources:
  - `google_compute_instance`
  - `google_compute_firewall`
- SSH keys automatically created for provisioning

---
