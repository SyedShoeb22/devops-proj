variable "gcp_credentials_file" {
  description = "Path to the GCP service account JSON credentials file"
  type        = string
}

variable "project" {
  description = "GCP project ID"
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
  description = "SSH public key content for VM access, format: 'ssh-rsa AAAAB3... user@host'"
  type        = string
}
