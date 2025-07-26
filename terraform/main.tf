terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}


locals {
  credentials = jsondecode(file(var.gcp_credentials_file))
}

provider "google" {
  credentials = file(var.gcp_credentials_file)
  project     = local.credentials.project_id
  region      = var.region
}

resource "google_compute_instance" "default" {
  name         = "example-vm"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Enables external IP
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key)}"
  }

  tags = ["http-server", "https-server"]
}

  labels = {
    goog-terraform-provisioned = "true"
  }
}

output "instance_ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}
