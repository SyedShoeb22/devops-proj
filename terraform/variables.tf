variable "gcp_credentials_file" {
  description = "Path to the GCP credentials JSON file"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "europe-west1-b"
}

variable "ssh_public_key" {
  description = "SSH public key to use for VM access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
