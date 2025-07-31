variable "gcp_credentials_file" {
  description = "Path to the GCP credentials JSON file"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "ssh_public_key" {
  description = "SSH public key to use for VM access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
variable "vm_name" {
  description = "Name of the VM to create"
  type        = string
  default     = "devops-instance"
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}
